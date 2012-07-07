package ui 
{
	import d2actions.PartyInvitation;
	import d2api.SystemApi;
	import d2api.UiApi;
	import d2components.ButtonContainer;
	import d2components.GraphicContainer;
	import d2components.Label;
	/**
	 * ...
	 * @author Relena
	 */
	public class InvitationUi 
	{
		//::///////////////////////////////////////////////////////////
		//::// Properties 
		//::///////////////////////////////////////////////////////////
		
		// APIs
		public var sysApi:SystemApi; // sendAction
		public var uiApi:UiApi; // addComponentHook, addShortcutHook
		
        // Components 
        public var lbl_pseudo:Label;
        public var btn_ok:ButtonContainer;
        public var btn_no:ButtonContainer;
		
		// Properties
		private var parent:MultiAccountInvitation;
		private var playerName:String;
		
        //::///////////////////////////////////////////////////////////
        //::// Public methods
        //::///////////////////////////////////////////////////////////
		
		public function main(params:Object) : void 
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
         
        public function unload() : void 
        { 
        } 
		
        //::///////////////////////////////////////////////////////////
        //::// Private methods
        //::///////////////////////////////////////////////////////////
		
		private function sendInvitationRoutine() : void
		{
			traceDofus("Invitation de " + playerName);
			sysApi.sendAction(new PartyInvitation(playerName));
			
			nextInvitationRoutine();
		}
		
		private function nextInvitationRoutine() : void
		{
			playerName = parent.getInvitationName();
			
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
		
		public function onShortcut(name:String) : Boolean
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
		
		public function onRelease(target:Object) : void
		{
			if (target == btn_ok)
			{
				sendInvitationRoutine();
			}
			else if (target == btn_no)
			{
				nextInvitationRoutine();
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