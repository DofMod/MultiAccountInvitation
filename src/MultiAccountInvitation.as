package
{
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
	
	/**
	 * The main class of the module. Manage multi accounts invitations.
	 * 
	 * @author	Relena
	 */
	public class MultiAccountInvitation extends Sprite
	{
		//::///////////////////////////////////////////////////////////
		//::// Properties
		//::///////////////////////////////////////////////////////////
		
		// Force include
		private static var linkages:Array = [InvitationUi];
		
		// APIs
		/**
		 * @private
		 */
		public var sysApi:SystemApi; // Hooks, Actions
		/**
		 * @private
		 */
		public var playerApi:PlayedCharacterApi; // Player name
		/**
		 * @private
		 */
		public var partyApi:PartyApi; // isInParty
		/**
		 * @private
		 */
		public var uiApi:UiApi; // loadUi
		
		// Components
		[Module(name = "MultiAccountManager")]
		/**
		 * MultiAccountManager module reference.
		 */
		public var modMultiAccountManager:Object;
		
		// Constants
		private const sendIdKey:String = "mai_sendId";
		private const receiveIdKey:String = "mai_receiveId";
		private const invitationUiName:String = "invitationui";
		
		// Properties
		private var invitationNames:Array;
		
		//::///////////////////////////////////////////////////////////
		//::// Methods
		//::///////////////////////////////////////////////////////////
		
		/**
		 * Initialize the module.
		 */
		public function main():void
		{
			invitationNames = new Array();
			
			sysApi.addHook(ChatSendPreInit, onChatSendPreInit);
			sysApi.addHook(GameStart, onGameStart);
		}
		
		/**
		 * Uninitialize the module.
		 */
		public function unload():void
		{
			//modMultiAccountManager.unregister(sendIdKey);
			//modMultiAccountManager.unregister(receiveIdKey);
		}
		
		/**
		 * Return the pseudo of a character who can be invited.
		 * 
		 * @return A character's pseudo
		 */
		public function getInvitationName():String
		{
			return invitationNames.pop();
		}
		
		/**
		 * Call the <code>receiveId</code> function of the account with
		 * <code>originIndex</code> index with player Id and player Name
		 * parameters.
		 * 
		 * @param	originIndex	The index of an account.
		 * 
		 * @private
		 */
		public function sendId(originIndex:int):void
		{
			modMultiAccountManager.send(
				originIndex,
				receiveIdKey,
				playerApi.getPlayedCharacterInfo().id,
				playerApi.getPlayedCharacterInfo().name);
		}
		
		/**
		 * Open invitation request popup
		 * (for <code>playerName</code> character).
		 * 
		 * @param	playerId	Id of the character.
		 * @param	playerName	Name of the character.
		 * 
		 * @private
		 */
		public function receiveId(playerId:uint, playerName:String):void
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
		
		/**
		 * GameStart event callback. Register function keys.
		 */
		private function onGameStart():void
		{
			modMultiAccountManager.register(sendIdKey, this.sendId);
			modMultiAccountManager.register(receiveIdKey, this.receiveId);
		}
		
		/**
		 * ChatSendPreInit event callback. Intercept /invitemulti command.
		 * 
		 * @param	message	Message sent.
		 * @param	objects	Linked objects list.
		 */
		private function onChatSendPreInit(message:String, objects:Object):void
		{
			if (message == "/invitemulti")
			{
				modMultiAccountManager.sendOther(
					sendIdKey,
					modMultiAccountManager.getIndex());
			}
		}
		
		//::///////////////////////////////////////////////////////////
		//::// Debug
		//::///////////////////////////////////////////////////////////
		
		/**
		 * Log message.
		 *
		 * @param	str	The string to display.
		 */
		private function traceDofus(str:String):void
		{
			sysApi.log(2, str);
		}
	}
}