<%--
  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
  --%>
<%@ page language="java" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<fmt:setBundle basename="messages"/>

<header>
    <nav class="topnav">
        <ul class="horizontal-list">
            <li>
                <a href="<spring:url value="/app/store/widget/add?referringPageId=${referringPageId}"/>"><fmt:message
                        key="page.addwidget.title"/></a>
            </li>
            <li>
                <c:choose>
                    <c:when test="${empty referringPageId}">
                        <spring:url value="/index.html" var="gobackurl"/>
                    </c:when>
                    <c:otherwise>
                        <spring:url value="/app/page/view/${referringPageId}" var="gobackurl"/>
                    </c:otherwise>
                </c:choose>
                <a href="<c:out value="${gobackurl}"/>"><fmt:message key="page.general.back"/></a>
            </li>
            <sec:authorize url="/app/admin/">
                <li>
                    <a href="<spring:url value="/app/admin/"/>">
                        <fmt:message key="page.general.toadmininterface"/>
                    </a>
                </li>
            </sec:authorize>
            <li>
                <a href="<spring:url value="/j_spring_security_logout" htmlEscape="true" />">
                    <fmt:message key="page.general.logout"/></a>
            </li>
        </ul>
    </nav>
    <h1>${pagetitle}</h1>
</header>

<div id="content" class="pageContent">

    <section class="storeSearch">
        <form action="<c:url value="/app/store/search"/>" method="GET">
            <fieldset>
                <input type="hidden" name="referringPageId" value="${referringPageId}">

                <h2>
                    <label for="searchTerm"><fmt:message key="page.store.search"/></label>
                </h2>
                <p>
                    <input type="search" id="searchTerm" name="searchTerm" value="<c:out value="${searchTerm}"/>"/>
                    <fmt:message key="page.store.search.button" var="searchButtonText"/>

                    <input type="submit" value="${searchButtonText}"/>
                    <c:if test="${not empty searchTerm}">
                        <a href="<spring:url value="/app/store?referringPageId=${referringPageId}"/>">
                            <fmt:message key="admin.clearsearch"/></a>
                    </c:if>
                </p>
            </fieldset>
        </form>

        <div>
            <a href="<spring:url value="/app/store/mine?referringPageId=${referringPageId}"/>"><fmt:message key="page.store.list.widgets.mine"/></a>
        </div>
        <div>
            <a href="<spring:url value="/app/store?referringPageId=${referringPageId}"/>"><fmt:message key="page.store.list.widgets.all"/></a>
        </div>
    </section>

    <section class="storeBox">
        <c:choose>
            <c:when test="${empty searchTerm and (empty widgets or widgets.totalResults eq 0)}">
                <%-- Empty db --%>
                <fmt:message key="page.store.list.noresult" var="listheader"/>
            </c:when>
            <c:when test="${empty searchTerm}">
                <fmt:message key="page.store.list.result.x.to.y" var="listheader">
                    <fmt:param value="${widgets.offset + 1}"/>
                    <fmt:param value="${widgets.offset + fn:length(widgets.resultSet)}"/>
                    <fmt:param value="${widgets.totalResults}"/>
                </fmt:message>
            </c:when>
            <c:when test="${not empty searchTerm and widgets.totalResults eq 0}">
                <fmt:message key="page.store.list.search.noresult" var="listheader">
                    <fmt:param><c:out value="${searchTerm}"/></fmt:param>
                </fmt:message>
            </c:when>
            <c:otherwise>
                <fmt:message key="page.store.list.search.result.x.to.y" var="listheader">
                    <fmt:param value="${widgets.offset + 1}"/>
                    <fmt:param value="${widgets.offset + fn:length(widgets.resultSet)}"/>
                    <fmt:param value="${widgets.totalResults}"/>
                    <fmt:param><c:out value="${searchTerm}"/></fmt:param>
                </fmt:message>
            </c:otherwise>
        </c:choose>
        <h2>${listheader}</h2>
            <%--@elvariable id="widgets" type="org.apache.rave.portal.model.util.SearchResult"--%>
        <c:if test="${widgets.totalResults gt 0}">
            <c:if test="${widgets.numberOfPages gt 1}">

                <ul class="paging">
                    <c:forEach var="i" begin="1" end="${widgets.numberOfPages}">
                        <c:url var="pageUrl" value="">
                            <c:param name="referringPageId" value="${referringPageId}"/>
                            <c:param name="searchTerm" value="${searchTerm}"/>
                            <c:param name="offset" value="${(i - 1) * widgets.pageSize}"/>
                        </c:url>

                        <li>
                            <c:choose>
                                <c:when test="${i eq widgets.currentPage}">
                                    <span class="currentPage">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:out value="${pageUrl}"/>">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                </ul>

            </c:if>

            <ul class="storeItems">
                    <%--@elvariable id="widget" type="org.apache.rave.portal.model.Widget"--%>
                <c:forEach var="widget"
                           items="${widgets.resultSet}">
                    <%--@elvariable id="widgetsStatistics" type="org.apache.rave.portal.model.util.WidgetStatistics"--%>
                    <c:set var="widgetStatistics" value="${widgetsStatistics[widget.entityId]}" />
                    <li class="storeItem">

                        <div class="storeItemLeft">
                            <c:if test="${not empty widget.thumbnailUrl}">
                                <img class="storeWidgetThumbnail" src="${widget.thumbnailUrl}"
                                     title="<c:out value="${widget.title}"/>" alt=""
                                     width="120" height="60"/>
                            </c:if>

                            <div id="widgetAdded_${widget.entityId}" class="storeButton">
                                <button class="storeItemButton"
                                        id="addWidget_${widget.entityId}"
                                        onclick="rave.api.rpc.addWidgetToPage({widgetId: ${widget.entityId}, pageId: ${referringPageId}, buttonId: this.id});">
                                    <fmt:message key="page.widget.addToPage"/>
                                </button>
                            </div>

                        </div>

                        <div class="storeItemCenter">

                            <a id="widget-${widget.entityId}-title"
                               class="secondaryPageItemTitle"
                               href="<spring:url value="/app/store/widget/${widget.entityId}" />?referringPageId=${referringPageId}">
                                <c:out value="${widget.title}"/>
                            </a>
                            <c:if test="${widget.disableRendering}">
                                <div class="storeWidgetDisabled">
                                    <span class="widget-disabled-icon-store ui-icon ui-icon-alert" title="<fmt:message key="widget.chrome.disabled"/>"></span>
                                    <c:out value="${widget.disableRenderingMessage}" escapeXml="true" />
                                </div>
                            </c:if>
                            <c:if test="${not empty widget.author}">
                                <div class="storeWidgetAuthor"><fmt:message key="widget.author"/>: <c:out
                                        value="${widget.author}"/></div>
                            </c:if>
                            <c:if test="${not empty widget.description}">
                                <div class="storeWidgetDesc"><c:out
                                        value="${fn:substring(widget.description, 0, 200)}..."/></div>
                            </c:if>
                            <div class="widgetRating">
                                <fmt:message key="page.widget.rate"/>
                                <c:set var="totalLikes" value="${widgetStatistics.totalLike}"/>
                                <c:set var="totalDislikes" value="${widgetStatistics.totalDislike}"/>

                                <div id="rating-${widget.entityId}" class="ratingButtons">
                                    <input type="radio" id="like-${widget.entityId}" class="widgetLikeButton"
                                           name="rating-${widget.entityId}"${widgetStatistics.userRating==10?" checked='true'":""}>
                                    <label for="like-${widget.entityId}">${widgetStatistics!=null?widgetStatistics.totalLike:"0"}</label>
                                    <input type="radio" id="dislike-${widget.entityId}" class="widgetDislikeButton"
                                           name="rating-${widget.entityId}"${widgetStatistics.userRating==0?" checked='true'":""}>
                                    <label for="dislike-${widget.entityId}">${widgetStatistics!=null?widgetStatistics.totalDislike:"0"}</label>
                                </div>
                            </div>
                            <div class="widgetUserCount">
                                <c:set var="widgetUserCountGreaterThanZero" value="${widgetStatistics != null && widgetStatistics.totalUserCount > 0}" />
                                <c:if test="${widgetUserCountGreaterThanZero}"><a href="javascript:void(0);" onclick="rave.displayUsersOfWidget(${widget.entityId});"></c:if>
                                    <fmt:formatNumber groupingUsed="true" value="${widgetStatistics!=null?widgetStatistics.totalUserCount:0}" />&nbsp;<fmt:message key="page.widget.usercount"/>
                                <c:if test="${widgetUserCountGreaterThanZero}"></a></c:if>
                            </div>
                        </div>

                        <div class="clear-float"></div>
                    </li>
                </c:forEach>
            </ul>

            <c:if test="${widgets.numberOfPages gt 1}">

                <ul class="paging">
                    <c:forEach var="i" begin="1" end="${widgets.numberOfPages}">
                        <c:url var="pageUrl" value="">
                            <c:param name="referringPageId" value="${referringPageId}"/>
                            <c:param name="searchTerm" value="${searchTerm}"/>
                            <c:param name="offset" value="${(i - 1) * widgets.pageSize}"/>
                        </c:url>

                        <li>
                            <c:choose>
                                <c:when test="${i eq widgets.currentPage}">
                                    <span class="currentPage">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:out value="${pageUrl}"/>">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                </ul>

            </c:if>
        </c:if>
    </section>

</div>

    <script src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
    <script src="//ajax.aspnetcdn.com/ajax/jquery.ui/1.8.16/jquery-ui.min.js"></script>
<!--[if lt IE 9]><script src=//css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js></script><![endif]-->
<script src="<spring:url value="/script/rave.js"/>"></script>
<script src="<spring:url value="/script/rave_api.js"/>"></script>
<script src="<spring:url value="/script/rave_store.js"/>"></script>
<script>
    $(function () {
        rave.setContext("<spring:url value="/app/" />");
        rave.store.init();
    });
</script>