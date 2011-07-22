/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.apache.shindig.gadgets.oauth.model;

import org.apache.shindig.social.opensocial.jpa.api.DbObject;

import javax.persistence.*;

import static javax.persistence.GenerationType.IDENTITY;

/**
 * Persistent store for OAuth consumer key & secrets.
 * Equivalent of:
 * <pre>
 * {
 *    "http://localhost:8080/samplecontainer/examples/oauth.xml" : {
 *      "" : {
 *          "consumer_key" : "gadgetConsumer",
 *          "consumer_secret" : "gadgetSecret",
 *          "key_type" : "HMAC_SYMMETRIC"
 *      }
 *  },
 *   "http://localhost:8080/samplecontainer/examples/shindigoauth.xml" : {
 *      "shindig" : {
 *          "consumer_key" : "http://localhost:8080/samplecontainer/examples/shindigoauth.xml",
 *          "consumer_secret" : "secret",
 *          "key_type" : "HMAC_SYMMETRIC"
 *      }
 *  }
 * }
 * </pre>
 */
@Entity
@Table(name = "oauth_consumer_store",
        uniqueConstraints = @UniqueConstraint(columnNames = {"gadget_uri", "service_name"}))
public class OAuthConsumerStoreDb implements DbObject {

    /**
     * enum of KeyType's
     */
    public static enum KeyType {
        HMAC_SYMMETRIC, RSA_PRIVATE, PLAINTEXT
    }

    @Id
    @GeneratedValue(strategy = IDENTITY)
    @Column(name = "oid")
    private long objectId;

    /**
     * URI where the gadget is hosted, e.g. http://www.example.com/mygadget.xml
     */
    @Column(name = "gadget_uri", length = 512)
    private String gadgetUri;

    /**
     * Name of the oAuth service, matches /Module/ModulePrefs/OAuth/Service/@name
     * in a gadget definition
     */
    @Column(name = "service_name")
    private String serviceName;


    /**
     * Value for oauth_consumer_key
     */
    @Column(name = "consumer_key")
    private String consumerKey;

    /**
     * HMAC secret, or RSA private key, depending on KeyType
     */
    @Column(name = "consumer_secret")
    private String consumerSecret;

    /**
     * Type of key, also known as "OAuth signature method"
     */
    @Enumerated(value = EnumType.STRING)
    @Column(name = "key_type")
    private KeyType keyType;

    /**
     * Name of public key to use with xoauth_public_key parameter.
     * May be {@literal null}.
     */
    @Column(name = "key_name")
    private String keyName;

    /**
     * Callback URL associated with this consumer key
     * May be {@literal null}.
     */
    @Column(name = "callback_url")
    private String callbackUrl;


    /**
     * {@inheritDoc}
     */
    @Override
    public long getObjectId() {
        return objectId;
    }

    public String getGadgetUri() {
        return gadgetUri;
    }

    public void setGadgetUri(String gadgetUri) {
        this.gadgetUri = gadgetUri;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getConsumerKey() {
        return consumerKey;
    }

    public void setConsumerKey(String consumerKey) {
        this.consumerKey = consumerKey;
    }

    public String getConsumerSecret() {
        return consumerSecret;
    }

    public void setConsumerSecret(String consumerSecret) {
        this.consumerSecret = consumerSecret;
    }

    public KeyType getKeyType() {
        return keyType;
    }

    public void setKeyType(KeyType keyType) {
        this.keyType = keyType;
    }

    public String getKeyName() {
        return keyName;
    }

    public void setKeyName(String keyName) {
        this.keyName = keyName;
    }

    public String getCallbackUrl() {
        return callbackUrl;
    }

    public void setCallbackUrl(String callbackUrl) {
        this.callbackUrl = callbackUrl;
    }
}
