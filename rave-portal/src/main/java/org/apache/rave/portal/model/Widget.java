/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.rave.portal.model;

import org.apache.rave.portal.model.util.InternationalString;

import javax.persistence.*;
import java.net.URL;

/**
 * A widget
 */
@Entity
@Table(name="widget")
@SequenceGenerator(name="widgetIdSeq", sequenceName = "widget_id_seq")
public class Widget {
    @Id @Column(name="id")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "widgetIdSeq")
    private Long id;

    /*
        TODO 1: Figure out what the OpenJPA strategy is for functionality provided by Eclisplink's @Convert
     */

    @Basic @Column(name="title")
    private String title;
    //private InternationalString title;

    @Basic @Column(name="url")
    private String url;

    /**
     * Gets the persistence unique identifier
     *
     * @return id The ID of persisted object; null if not persisted
     */
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    //See TODO 1
//    public InternationalString getTitle() {
//        return title;
//    }
//
//    public void setTitle(InternationalString title) {
//        this.title = title;
//
// }


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}