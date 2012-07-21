package {
	import d2actions.ChatTextOutput;
	import d2actions.PartyInvitation;
	import d2api.PartyApi;
	import d2api.PlayedCharacterApi;
	import d2api.SystemApi;
	import d2api.UiApi;
	import d2enums.ChatChannelsMultiEnum;
	import d2hooks.ChatError;
	import d2hooks.ChatSendPreInit;
	import d2hooks.GameStart;
	import flash.display.Sprite;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.Dictionary;
	import ui.InvitationUi;

	public class MultiAccountInvitation extends Sprite
	{
		//::///////////////////////////////////////////////////////////
		//::// Properties
		//::///////////////////////////////////////////////////////////
		
		// Force include
		private static var linkages:Array = [InvitationUi];
		
		// APIs
		public var sysApi:SystemApi; // Hooks, Actions
		public var playerApi:PlayedCharacterApi; // Player name
		public var partyApi:PartyApi; // isInParty
		public var uiApi:UiApi; // loadUi
		
		// Components
		[Module (name="MultiAccountManager")]
		public var modMultiAccountManager : Object;
		
		// Constants
		private const sendIdKey:String = "mai_sendId";
		private const receiveIdKey:String = "mai_receiveId";
		private const invitationUiName:String = "invitationui";
		
		// Properties
		private var invitationNames:Array;
		
		//::///////////////////////////////////////////////////////////
		//::// Methods
		//::///////////////////////////////////////////////////////////

		public function main() : void
		{
			invitationNames = new Array();
			
			sysApi.addHook(ChatSendPreInit, onChatSendPreInit);
			sysApi.addHook(GameStart, onGameStart);
		}
		
		public function unload() : void
		{
			//modMultiAccountManager.unregister(sendIdKey);
			//modMultiAccountManager.unregister(receiveIdKey);
		}
		
		public function getInvitationName() : String
		{
			return invitationNames.pop();
		}
		
		public function sendId(originIndex:int) : void
		{
			modMultiAccountManager.send(
					originIndex,
					receiveIdKey,
					playerApi.getPlayedCharacterInfo().id,
					playerApi.getPlayedCharacterInfo().name
					);
		}
		
		public function receiveId(playerId:uint, playerName:String) : void
		{
			if (partyApi.isInParty(playerId))
				return;

			invitationNames.push(playerName);
			
			if (uiApi.getUi(invitationUiName) == null)
			{
				uiApi.loadUi(invitationUiName, invitationUiName, this);
			}
		}
			
		//::///////////////////////////////////////////////////////////
		//::// Events
		//::///////////////////////////////////////////////////////////
		
		public function onGameStart() : void
		{
			modMultiAccountManager.register(sendIdKey, this.sendId);
			modMultiAccountManager.register(receiveIdKey, this.receiveId);
		}
		
		public function onChatSendPreInit(string:String, arg1:Object) : void
		{
			if (string == "/invitemulti")
			{				
				modMultiAccountManager.sendOther(
						sendIdKey,
						modMultiAccountManager.getIndex()
						);
			}
		}
		
		//::///////////////////////////////////////////////////////////
		//::// Debug
		//::///////////////////////////////////////////////////////////
		
		private function traceDofus(str:String) : void
		{
			sysApi.log(2, str);
		}
	}
}
