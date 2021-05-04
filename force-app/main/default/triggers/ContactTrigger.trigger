trigger ContactTrigger on Contact (after insert) {
	if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			List<Account> accountList = new List<Account>();
			List<Contact> contactUpdateList = new List<Contact>();
			Map<String, Account> accountMap = new Map<String, Account>();
			Set<String> accountIdSet = new Set<String>();

			for(Contact con : Trigger.new) {
				accountIdSet.add(con.AccountId);
			}
			accountList = [SELECT Id, Total_Contacts__c FROM Account WHERE Id IN :accountIdSet];

			if(accountList == null || accountList.isEmpty()) {
				return;
			}
			for(Account acc : accountList) {
				accountMap.put(acc.Id, acc);
			}
			for (Contact con : Trigger.new) {
				if(accountMap.containsKey(con.AccountId)) {
					Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
					approvalRequest.setComments('Contact Submitted for approval');
					approvalRequest.setObjectId(con.Id);
					Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
					if(approvalResult .isSuccess()) {
						Contact conUpdate = new Contact();
						conUpdate.Id = con.Id;
						conUpdate.Active__c = true;
						contactUpdateList.add(conUpdate);
						if(accountMap.get(con.AccountId).Total_Contacts__c == null ) {
							accountMap.get(con.AccountId).Total_Contacts__c = 0;
						} else {
							accountMap.get(con.AccountId).Total_Contacts__c = accountMap.get(con.AccountId).Total_Contacts__c + 1;
						}
					}
				}
			}
			if(!contactUpdateList.isEmpty()) {
				update contactUpdateList;
				update accountMap.values();
			}
		}
	}
}