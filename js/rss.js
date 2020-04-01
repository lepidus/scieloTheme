/* Fetch the RSS Feed */
// JS beforeend way

var http_request;
http_request = new XMLHttpRequest();
http_request.onreadystatechange = function () { /* .. */ };
http_request.open("POST", "https://blog.scielo.org/");
http_request.withCredentials = true;
http_request.setRequestHeader("Content-Type", "application/json");
http_request.send({ 'request': "authentication token" });

fetch('https://blog.scielo.org/feed')
	.then(response => response.text())
	.then(str => new window.DOMParser().parseFromString(str, "text/xml"))
	.then(data => {
		console.log(data);
		const items = data.querySelectorAll("item");
		let html = ``;
		items.forEach(el => {
			html += `
				<div>
					<h2>
					<a href="${el.querySelector("link").innerHTML}" target="_blank" rel="noopener">
						${el.querySelector("title").innerHTML}
					</a>
					</h2>
				</div>
			`;
	});
	var temp = document.getElementById("feed");  
	temp.insertAdjacentHTML("beforeend", html);
});

    
// jQuery(function() {

//     jQuery.getFeed({
//         url: 'https://blog.scielo.org/feed',
//         success: function(feed) {
        
//             var html = '';
            
//             for(var i = 0; i < feed.items.length && i < 5; i++) {
            
//                 var item = feed.items[i];
                
//                 html += '<h3>'
//                 + '<a href="'
//                 + item.link
//                 + '">'
//                 + item.title
//                 + '</a>'
//                 + '</h3>';
                
//                 html += '<div class="updated">'
//                 + item.updated
//                 + '</div>';
                
//                 html += '<div>'
//                 + item.description
//                 + '</div>';
//             }
            
//             jQuery('#result').append(html);
//         }    
//     });
// });
