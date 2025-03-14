/*
 *  Copyright (c) 2023 Bayerische Motoren Werke Aktiengesellschaft (BMW AG)
 *
 *  This program and the accompanying materials are made available under the
 *  terms of the Apache License, Version 2.0 which is available at
 *  https://www.apache.org/licenses/LICENSE-2.0
 *
 *  SPDX-License-Identifier: Apache-2.0
 *
 *  Contributors:
 *       Bayerische Motoren Werke Aktiengesellschaft (BMW AG) - initial API and implementation
 *
 */

package org.eclipse.edc.demo.dcp.ih;

import org.eclipse.edc.identityhub.spi.verifiablecredentials.model.VerifiableCredentialResource;
import org.eclipse.edc.identityhub.spi.verifiablecredentials.store.CredentialStore;
import org.eclipse.edc.runtime.metamodel.annotation.Extension;
import org.eclipse.edc.runtime.metamodel.annotation.Inject;
import org.eclipse.edc.spi.monitor.Monitor;
import org.eclipse.edc.spi.system.ServiceExtension;
import org.eclipse.edc.spi.system.ServiceExtensionContext;
import org.eclipse.edc.spi.types.TypeManager;

import java.io.IOException;
import java.util.stream.Stream;

import static org.eclipse.edc.spi.constants.CoreConstants.JSON_LD;


@Extension("DCP Demo: Core Extension for IdentityHub")
public class IdentityHubExtension implements ServiceExtension {

    @Inject
    private CredentialStore store;

    @Inject
    private TypeManager typeManager;
    private Monitor monitor;


    @Override
    public void initialize(ServiceExtensionContext context) {
        monitor = context.getMonitor().withPrefix("DEMO");
    }

    @Override
    public void start() {
        try {
            seedCredentials(monitor);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void seedCredentials(Monitor monitor) throws IOException {

        var mapper = typeManager.getMapper(JSON_LD);

        Stream.of("dataprocessor-credential.json", "membership-credential.json")
                .forEach(resourceName -> {

                    try (var is = getClass().getClassLoader().getResourceAsStream(resourceName)) {
                        var credential = mapper.readValue(is, VerifiableCredentialResource.class);
                        store.create(credential);
                        monitor.info("Stored VC from resource '%s'".formatted(resourceName));

                    } catch (IOException e) {
                        monitor.severe("Error storing VC", e);
                    }
                });
    }
}
