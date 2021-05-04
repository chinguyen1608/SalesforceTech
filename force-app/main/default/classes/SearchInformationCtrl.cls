global class SearchInformationCtrl {
	public String searchText {get; set;}
	public List<Info> searchInfoList {get; set;}
	public SearchInformationCtrl() {
		this.searchText = '';
		this.searchInfoList = new List<Info>();
	}
	
	public void searchInformation() {
		this.searchInfoList = new List<Info>();
		if(String.isBlank(this.searchText)) {
			return;
		}
		List<Account> accountList = [SELECT Id, Name, Counter__c
									 FROM Account
									 WHERE Name LIKE :'%' + String.escapeSingleQuotes(this.searchText) + '%'];
		List<Contact> contactList = [SELECT Id, Name, Counter__c
									 FROM Contact
									 WHERE Name LIKE :'%' + String.escapeSingleQuotes(this.searchText) + '%'];
		
 
		for(Account acc : accountList) {
			Info accInfo = new Info(acc);
			searchInfoList.add(accInfo);
		}
		for(Contact con : contactList) {
			Info conInfo = new Info(con);
			searchInfoList.add(conInfo);
		}
	}
	
	@RemoteAction
	global static Decimal incrementCounter(Id recordId) {
		System.debug('aaaaaaaaa: ' + SObjectType.Account.getLabel().equals(recordId.getSobjectType()));
		if(SObjectType.Account.getLabel().equals(recordId.getSObjectType().getDescribe().getName())) {
			Account acc = [SELECT Id, Counter__c FROM Account WHERE Id =: recordId LIMIT 1];
			if(acc != null || String.isNotBlank(acc.Id)) {
				if(acc.Counter__c == null) {
					acc.Counter__c = 1;
				} else {
					acc.Counter__c = acc.Counter__c + 1;
				}
				update acc;
				System.debug('acc: ' + acc);
				return acc.Counter__c;
			}
		}

		if(SObjectType.Contact.getLabel().equals(recordId.getSObjectType().getDescribe().getName())) {
			Contact con = [SELECT Id, Counter__c FROM Contact WHERE Id =: recordId LIMIT 1];
			if(con != null || String.isNotBlank(con.Id)) {
				if(con.Counter__c == null) {
					con.Counter__c = 1;
				} else {
					con.Counter__c = con.Counter__c + 1;
				}
				update con;
				System.debug('con: ' + con);
				return con.Counter__c;
			}
		}
		return 0;
	}

	public class Info {
		public Id recordId {get; set;}
		public String name {get; set;}
		public Decimal counter {get; set;}
		public String labelObject {get; set;}

		public Info() {
			this.recordId = '';
			this.name = '';
			this.counter = null;
			this.labelObject = '';
		}

		public Info(Account acc) {
			this.recordId = acc.Id;
			this.name = acc.Name;
			this.counter = acc.Counter__c;
			this.labelObject = SObjectType.Account.getLabel();
		}

		public Info(Contact con) {
			this.recordId = con.Id;
			this.name = con.Name;
			this.counter = con.Counter__c;
			this.labelObject = SObjectType.Contact.getLabel();
		}
	}
}