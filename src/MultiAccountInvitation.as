package
{
	import d2actions.PartyInvitation;
	import d2api.PartyApi;
	import d2api.PlayedCharacterApi;
	import d2api.SystemApi;
	import d2api.UiApi;
	import d2hooks.ChatSendPreInit;
	import d2hooks.GameStart;
	import flash.display.Sprite;
	
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
		
		// APIs
		/**
		 * @private
		 */
		public var sysApi:SystemApi; // addHooks, sendActions
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
		public var uiApi:UiApi; // getText
		
		// Components
		[Module(name = "MultiAccountManager")]
		/**
		 * MultiAccountManager module reference.
		 */
		public var modMultiAccountManager:Object;
		
		[Module(name = "Ankama_Common")]
		/**
		 * Ankama_Common module reference.
		 */
		public var modCommon:Object;
		
		// Constants
		private const sendIdKey:String = "mai_sendId";
		private const receiveIdKey:String = "mai_receiveId";
		
		//::///////////////////////////////////////////////////////////
		//::// Methods
		//::///////////////////////////////////////////////////////////
		
		/**
		 * Initialize the module.
		 */
		public function main():void
		{
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
			
			var sendInvitation:Function = function():void
			{
				sysApi.sendAction(new PartyInvitation(playerName));
			}
			
			modCommon.openPopup(
				uiApi.getText("ui.exchange.exchangeRequest"),
				"Inviter : " + playerName,
				[uiApi.getText("ui.common.yes"), uiApi.getText("ui.common.no")],
				[sendInvitation, null],
				sendInvitation);
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
	}
}