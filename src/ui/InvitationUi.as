package ui
{
	import d2actions.PartyInvitation;
	import d2api.SystemApi;
	import d2api.UiApi;
	import d2components.ButtonContainer;
	import d2components.GraphicContainer;
	import d2components.Label;
	
	/**
	 * Invitation popup.
	 *
	 * @author Relena
	 */
	public class InvitationUi
	{
		//::///////////////////////////////////////////////////////////
		//::// Properties 
		//::///////////////////////////////////////////////////////////
		
		// APIs
		/**
		 * @private
		 */
		public var sysApi:SystemApi; // log
		/**
		 * @private
		 */
		public var uiApi:UiApi; // addComponentHook, addShortcutHook
		
		// Components
		/**
		 * @private
		 */
		public var lbl_pseudo:Label;
		/**
		 * @private
		 */
		public var btn_ok:ButtonContainer;
		/**
		 * @private
		 */
		public var btn_no:ButtonContainer;
		
		// Properties
		private var parent:MultiAccountInvitation;
		private var playerName:String;
		
		//::///////////////////////////////////////////////////////////
		//::// Methods
		//::///////////////////////////////////////////////////////////
		
		/**
		 * Initialize the UI.
		 *
		 * @param	params	Divers parameters.
		 */
		public function main(params:Object):void
		{
			parent = params as MultiAccountInvitation;
			
			playerName = parent.getInvitationName();
			if (playerName == null)
			{
				traceDofus("Error: Pas de nom d'invitation disponible.");
				uiApi.unloadUi(uiApi.me().name);
			}
			
			lbl_pseudo.text = playerName;
			
			uiApi.addComponentHook(btn_ok, "onRelease");
			uiApi.addComponentHook(btn_no, "onRelease");
			
			uiApi.addShortcutHook("validUi", onShortcut);
			uiApi.addShortcutHook("closeUi", onShortcut);
		}
		
		/**
		 * Uninitialize the UI.
		 */
		public function unload():void
		{
		}
		
		/**
		 * Send PartyInvitation action.
		 */
		private function sendInvitationRoutine():void
		{
			parent.sendInvitation(this.playerName);
		}
		
		/**
		 * Load next player's name.
		 */
		private function nextInvitationRoutine():void
		{
			this.playerName = parent.getInvitationName();
			
			if (playerName == null)
			{
				uiApi.unloadUi(uiApi.me().name);
			}
			else
			{
				lbl_pseudo.text = playerName;
			}
		}
		
		//::///////////////////////////////////////////////////////////
		//::// Events 
		//::///////////////////////////////////////////////////////////
		
		/**
		 * Shortcut event callback.
		 *
		 * @param	name	Shortcut's name.
		 *
		 * @return	True if shortcut handled, False else.
		 */
		private function onShortcut(name:String):Boolean
		{
			if (name == "validUi")
			{
				sendInvitationRoutine();
				
				return true;
			}
			else if (name == "closeUi")
			{
				nextInvitationRoutine();
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Release event callback.
		 *
		 * @param	target	Released button.
		 * 
		 * @private
		 */
		public function onRelease(target:Object):void
		{
			if (target == btn_ok)
			{
				sendInvitationRoutine();
				nextInvitationRoutine();
			}
			else if (target == btn_no)
			{
				nextInvitationRoutine();
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