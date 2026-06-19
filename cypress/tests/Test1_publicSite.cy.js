describe('SciELO Theme - Public site features', function () {
    it('Index page should list latest preprints', function () {
		cy.visit('');

        cy.contains('h2', 'Latest preprints');
        cy.contains('Finocchiaro: Arguments About Arguments').parent().parent().within(() => {
            cy.contains('Zita Woods (Author)');
        });
        cy.contains('Self-Organization in Multi-Level Institutions').parent().parent().within(() => {
            cy.contains('Valerie Williamson (Author)');
        });
    });
    it('Preprint page should have date submitted', function () {
        cy.visit('');
        cy.contains('Finocchiaro: Arguments About Arguments').click();

        cy.contains('h1', 'Finocchiaro: Arguments About Arguments');
        cy.get('div.submitted').within(() => {
            cy.contains('Submitted');
            cy.contains('2025-11-05');
        });
    });
});