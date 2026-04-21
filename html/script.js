(function () {
    const el = (id) => document.getElementById(id);
    const splash = el('splash');

    let links = { discord: '', website: '' };

    function show(data) {
        if (data.background) {
            document.querySelector('.backdrop').style.backgroundImage = `url("${data.background}")`;
        }
        if (data.guildIcon) el('guildIcon').src = data.guildIcon;
        el('title').textContent       = data.title    || 'Welcome';
        el('subtitle').textContent    = data.subtitle || '';
        el('guildName').textContent   = data.guildName || '';
        el('memberCount').textContent = data.memberCount || 0;
        el('onlineCount').textContent = data.onlineCount || 0;

        links.discord = data.discord || '';
        links.website = data.website || '';

        splash.classList.remove('hidden');
    }

    function hide() {
        splash.classList.add('hidden');
        el('copied').classList.add('hidden');
    }

    function post(name, payload) {
        const res = typeof GetParentResourceName === 'function'
            ? GetParentResourceName()
            : 'C8N_Discord_API';
        fetch(`https://${res}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload || {})
        }).catch(() => {});
    }

    window.addEventListener('message', (ev) => {
        const msg = ev.data || {};
        if (msg.action === 'show')   show(msg.data || {});
        if (msg.action === 'hide')   hide();
        if (msg.action === 'copied') {
            const c = el('copied');
            c.textContent = 'Link: ' + msg.url;
            c.classList.remove('hidden');
        }
    });

    document.addEventListener('keyup', (e) => {
        if (e.key === 'Escape') post('close');
    });

    el('btnClose').addEventListener('click',   () => post('close'));
    el('btnDiscord').addEventListener('click', () => {
        if (links.discord) post('openUrl', { url: links.discord });
    });
    el('btnWebsite').addEventListener('click', () => {
        if (links.website) post('openUrl', { url: links.website });
    });
})();
