from locust import HttpUser, task, between
import os
import json

class PresentationQuery(HttpUser):
    wait_time = between(1, 5)  # Simulates users waiting between 1 to 5 seconds between requests
    
    def on_start(self):
        self.client.headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + os.getenv('ID_TOKEN')
            }


    @task
    def request_presentation(self):
        self.client.post(
            url="/presentations/query",
            data=json.dumps({
                "@context": [
                    "https://identity.foundation/presentation-exchange/submission/v1",
                    "https://w3id.org/dspace-dcp/v1.0/dcp.jsonld"
                ],
                "@type": "PresentationQueryMessage",
                "scope": [
                    "org.eclipse.edc.vc.type:MembershipCredential:read"
                ]
            }),
            name="Request Presentation",
        )