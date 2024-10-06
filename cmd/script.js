window.addEventListener('message', function(event) {
    if (event.data.action == "copyToClipboard") {
        const el = document.createElement('textarea');
        el.value = event.data.text;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
        console.log('Coordonnées copiées dans le presse-papier : ' + event.data.text);
    }
});
