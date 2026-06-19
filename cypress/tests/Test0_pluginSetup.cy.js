describe('SciELO Theme - Plugin setup', function () {
    it('Enables and selects SciELO Theme as current theme', function () {
		cy.login('dbarnes', null, 'publicknowledge');

		cy.get('nav').contains('Settings').click();
		cy.get('nav').contains('Website').click({ force: true });
		cy.get('button[id="plugins-button"]').click();

		cy.get('input[id^=select-cell-scielothemeplugin]').check();
		cy.get('input[id^=select-cell-scielothemeplugin]').should('be.checked');
		cy.reload();

		cy.get('button[id="appearance-button"]').click();
		cy.get('#theme-button').click();
		cy.get('select[name="themePluginPath"]').select('SciELO Theme');

		cy.contains('Usage statistics display options');
        cy.contains('button', 'Save').click();
		cy.get('.pkpFormPage__status:contains("Saved")');

        cy.logout();
    });
});