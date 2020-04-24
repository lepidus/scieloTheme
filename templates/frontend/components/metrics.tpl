{**
 * templates/frontend/components/metrics.tpl
*}

{capture assign=countJournals}{$scieloMetricsDAO->getJournalCount()}{/capture}
{capture assign=countPublications}{$scieloMetricsDAO->getPublicationCount()}{/capture}
{capture assign=countCitations}{$scieloMetricsDAO->getCitationCount()}{/capture}

<div class="row">
    <div class="col-md-12 col-sm-12 metrics">
        <div class="row">
            <div class="col-md-6">
            <h2>Métricas</h2>
            </div>
            <div class="col-md-6 right">
            <div class="datetime"><span id="date"></span></div>
            </div>
        </div>
        <div class="levelMenu">
            <div class="col-md-10 col-sm-10 numbers">
                <div class="col-md-3 col-sm-3">
                    {$countJournals}
                    <span>Preprints</span>
                </div>
                <div class="col-md-3 col-sm-3">
                    {$countPublications}
                    <span>Artigos</span>
                </div>
                    <div class="col-md-3 col-sm-3">
                    {$countCitations}
                    <span>Referências</span>
                </div>
            </div>
            <div class="clearfix"></div>
        </div>
    </div>
</div>
