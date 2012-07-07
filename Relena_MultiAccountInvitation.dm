<module>

    <!-- Information sur le module -->
    <header>
        <!-- Nom affiché dans la liste des modules -->
        <name>MultiAccountInvitation</name>        
        <!-- Version du module -->
        <version>1.0</version>
        <!-- Dernière version de dofus pour laquelle ce module fonctionne -->
        <dofusVersion>2.6.0</dofusVersion>
        <!-- Auteur du module -->
        <author>Relena</author>
        <!-- Courte description -->
        <shortDescription>Invitation en groupe pour multi-comptes</shortDescription>
        <!-- Description détaillée -->
        <description>Ce module détecte les comptes connectés sur un même ordinateur, et propose de les inviter dans un même groupe.</description>
	</header>

    <!-- Liste des interfaces du module, avec nom de l'interface, nom du fichier squelette .xml et nom de la classe script d'interface -->
    <uis>
		<ui name="invitationui" file="xml/InvitationUi.xml" class="ui::InvitationUi" />
    </uis>
    
    <script>MultiAccountInvitation.swf</script>
    
</module>
