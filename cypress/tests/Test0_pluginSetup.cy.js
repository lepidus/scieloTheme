describe('SciELO Theme - Plugin setup', function () {
    it('Enables SciELO Theme plugin', function () {
		cy.login('dbarnes', null, 'publicknowledge');

		cy.get('nav').contains('Settings').click();
		cy.get('nav').contains('Website').click({ force: true });
		cy.get('button[id="plugins-button"]').click();

		cy.get('input[id^=select-cell-scielothemeplugin]').check();
		cy.get('input[id^=select-cell-scielothemeplugin]').should('be.checked');
		cy.waitJQuery();

		cy.get('button[id="appearance-button"]').click();
		cy.get('#theme-button').click();
		cy.get('#theme-themePluginPath-control').select('SciELO Theme');

		cy.contains('Usage statistics display options');
		cy.get('button:visible:contains("Save")').click();
		cy.get('.pkpFormPage__status:contains("Saved")');
    });
});