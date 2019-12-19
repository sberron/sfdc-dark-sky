public class DarkSkyCallout {

    @AuraEnabled(cacheable=true)
    public static Forecast performCallout(Double latitude, Double longitude) {
        Http http = new Http();

        HttpRequest request= new HttpRequest();
        String key = [SELECT Secret_Key__c
                        FROM API_Setting__mdt
                        WHERE MasterLabel = 'Dark Sky'][0].Secret_Key__c;
        request.setEndpoint('https://api.darksky.net/forecast/' + key + '/' + latitude + ',' + longitude);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        return parseResponse(responseBody);

    }

    public static Forecast parseResponse(String response) {
        response = response.replace('"time":', '"time_x":');
        return (Forecast) System.JSON.deserialize(response, Forecast.class);
    }
}