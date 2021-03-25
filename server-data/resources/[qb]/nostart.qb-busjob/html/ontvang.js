$(function()
{
    window.addEventListener('message', function(event)
    {
		
		
        var item = event.data;
        var buf = $('#body');
		
		
		if (item.meta && item.meta == 'speed')
		{
			document.getElementById("speed").innerHTML = item.text
		
		}
		
		if (item.meta && item.meta == 'tijd')
		{
			document.getElementById("tijd").innerHTML = item.text
		
		}
		
		if (item.meta && item.meta == 'halte')
		{
			document.getElementById("halte").innerHTML = item.text
		
		}
		
		if (item.meta && item.meta == 'passengers')
		{
			document.getElementById("passengers").innerHTML = item.text
		
		}
		
		if (item.meta && item.meta == 'geld')
		{
			document.getElementById("geld").innerHTML = item.text
		
		}
		
		if (item.meta && item.meta == 'datum')
		{
			document.getElementById("datum").innerHTML = item.text
		
		}
		
		if (item.meta && item.meta == 'brandstof')
		{
			document.getElementById("brandstof").innerHTML = item.text
			document.getElementById("barndstof-p").style.width = item.width
		
		}
		
		if (item.meta && item.meta == 'stop')
		{
			document.getElementById("stop").style.visibility = item.text
		
		}
		
		if (item.meta && item.meta == 'lijn')
		{
			document.getElementById("lijn").innerHTML = item.text
		
		}
		
		if (item.meta && item.meta == 'deur-open')
		{
			document.getElementById("deur-dicht").style.visibility = 'hidden'
			document.getElementById("deur-open").style.visibility = 'visible'
		
		}
		
		if (item.meta && item.meta == 'deur-closed')
		{
			document.getElementById("deur-dicht").style.visibility = 'visible'
			document.getElementById("deur-open").style.visibility = 'hidden'
		
		}
		
		if (item.meta && item.meta == 'close')
        {
            $('#body').hide();
            return;
        }
		
		if (item.meta && item.meta == 'open')
        {
			$('#body').show();
            return;
        }

    }, false);
	
});