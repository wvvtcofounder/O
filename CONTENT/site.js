/* WVVT Site — Markdown renderer + nav builder */

(function () {
  const defined = { nav: document.getElementById('nav'), content: document.getElementById('content') };
  if (!defined.nav || !defined.content) return;

  const params = new URLSearchParams(window.location.search);
  const page = params.get('page') || 'index.md';

  // Build nav from pages.json
  fetch('pages.json')
    .then(r => r.json())
    .then(pages => {
      pages.forEach(p => {
        const a = document.createElement('a');
        a.href = p.file === 'index.md' ? './' : '?page=' + p.file;
        a.textContent = p.title;
        if (p.file === page || (page === 'index.md' && p.file === 'index.md' && !params.has('page'))) {
          a.classList.add('active');
        }
        defined.nav.appendChild(a);
      });
    })
    .catch(() => {}); // nav is non-critical

  // Fetch and render markdown
  fetch(page)
    .then(r => {
      if (!r.ok) throw new Error(r.status);
      return r.text();
    })
    .then(md => {
      defined.content.innerHTML = marked.parse(md);
    })
    .catch(() => {
      defined.content.innerHTML = '<h1>Page not found</h1><p>Could not load <code>' +
        page.replace(/</g, '&lt;') + '</code>.</p>';
    });
})();
