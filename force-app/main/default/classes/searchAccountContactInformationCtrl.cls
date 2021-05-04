global class searchAccountContactInformationCtrl {
	public String searchText {get; set;}
	// public SearchInfo searchInfo {get; set;}
	// public static Decimal counter { get; set; }
	public List<Info> searchInfoList {get; set;}
	public searchAccountContactInformationCtrl() {
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
		if(SObjectType.Account.getLabel().equals(recordId.getSobjectType())) {
			Account acc = [SELECT Id, Counter__c FROM Account WHERE Id =: recordId];
			if(acc != null || String.isNotBlank(acc.Id)) {
				acc.Counter__c = acc.Counter__c + 1;
				update acc;
				return acc.Counter__c;
			}
		}

		if(SObjectType.Contact.getLabel().equals(recordId.getSobjectType())) {
			Contact con = [SELECT Id, Counter__c FROM Contact WHERE Id =: recordId];
			if(con != null || String.isNotBlank(con.Id)) {
				con.Counter__c = con.Counter__c + 1;
				update con;
				return con.Counter__c;
			}
		}
		return 0;
	}
	// public class searchInfo {
	// 	public List<AccountInfo> accountSearchList {get; set;}
	// 	public List<ContactInfo> contactSearchList {get; set;}
		
	// 	public searchInfo() {
	// 		this.accountSearchList = new List<AccountInfo>();
	// 		this.contactSearchList = new List<ContactInfo>();
	// 	}
	// }
	// public class AccountInfo {
	// 	public Account accountSearch {get; set;}
	// 	public String labelAccount {get; set;}
		
	// 	public AccountInfo() {
	// 		this.accountSearch = new Account();
	// 		this.labelAccount = SObjectType.Account.getLabel();
	// 	}
		
	// 	public AccountInfo(Account acc) {
	// 		this.accountSearch = acc;
	// 		this.labelAccount = SObjectType.Account.getLabel();
	// 	}
	// }
	
	// public class ContactInfo {
	// 	public Contact contactSearch {get; set;}
	// 	public String labelContact {get; set;}
		
	// 	public ContactInfo() {
	// 		this.contactSearch = new Contact();
	// 		this.labelContact = SObjectType.Contact.getLabel();
	// 	}
		
	// 	public ContactInfo(Contact con) {
	// 		this.contactSearch = con;
	// 		this.labelContact = SObjectType.Contact.getLabel();
	// 	}
	// }
	
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