@RestResource(urlMapping='/Contact/*')
global with sharing class ContactRestResource {
	@HttpPut
	global static void updateContacts(String contactId) {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		List<String> contactIdList = contactId.split(',');
		List<Contact> contactListUpdate = [SELECT Id FROM Contact WHERE Id IN :contactIdList];
		update contactListUpdate;
	}
}