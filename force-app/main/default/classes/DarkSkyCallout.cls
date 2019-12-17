public class DarkSkyCallout {

    public Forecast forecast = new Forecast();
    private Double latitude;
    private Double longitude;
    
    public DarkSkyCallout(Double latitude, Double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public void performCallout() {
        Http http = new Http();

        HttpRequest request= new HttpRequest();
        String key = [SELECT Secret_Key__c
                        FROM API_Setting__mdt
                        WHERE MasterLabel = 'Dark Sky'][0].Secret_Key__c;
        request.setEndpoint('https://api.darksky.net/forecast/' + key + '/' + latitude + ',' + longitude);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        parseResponse(responseBody);

    }

    public void parseResponse(String response) {
        System.debug('before ' + response);
        response = response.replace('"time":', '"time_x":');
        System.debug('after ' + response);
        this.forecast = (Forecast) System.JSON.deserialize(response, Forecast.class);

    }
}