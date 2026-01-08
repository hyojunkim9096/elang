(function () {
  function api(path) { return '/api/admin/cms' + path; }
  function getLang() { return $('#langSelect').val(); }

  function jsonAjax(method, url, body, ok, fail) {
    $.ajax({
      method: method,
      url: url,
      data: body ? JSON.stringify(body) : null,
      contentType: 'application/json; charset=utf-8',
      dataType: 'json'
    }).done(ok).fail(function (xhr) {
      const msg = (xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : ('HTTP ' + xhr.status);
      alert(msg);
      if (fail) fail(xhr);
    });
  }

  function loadLayout() {
    const lang = getLang();
    jsonAjax('GET', api('/layout?lang=' + lang), null, function (res) {
      $('#headerHtml').val(res.data.headerHtml || '');
      $('#footerHtml').val(res.data.footerHtml || '');
    });
  }

  function saveLayout() {
    const lang = getLang();
    const body = { headerHtml: $('#headerHtml').val(), footerHtml: $('#footerHtml').val() };
    jsonAjax('PUT', api('/layout?lang=' + lang), body, function () {
      alert('레이아웃 저장 완료');
    });
  }

  function loadMenus() {
    const lang = getLang();
    jsonAjax('GET', api('/menus?lang=' + lang), null, function (res) {
      const tbody = $('#menuTable tbody').empty();
      (res.data || []).forEach(function (m) { tbody.append(renderMenuRow(m)); });
    });
  }

  function renderMenuRow(m) {
    const tr = $('<tr/>');
    tr.append($('<td/>').text(m.id || ''));
    tr.append($('<td/>').append($('<input class="m-label"/>').val(m.label || '')));
    tr.append($('<td/>').append($('<input class="m-href"/>').val(m.href || '')));
    tr.append($('<td/>').append($('<input class="m-sort" type="number"/>').val(m.sortOrder ?? 0)));

    const sel = $('<select class="m-enabled"><option value="true">true</option><option value="false">false</option></select>');
    sel.val(String(!!m.enabled));
    tr.append($('<td/>').append(sel));

    const btnSave = $('<button class="btn primary">저장</button>').on('click', function () {
      const lang = getLang();
      const body = {
        lang: lang,
        label: tr.find('.m-label').val(),
        href: tr.find('.m-href').val(),
        sortOrder: parseInt(tr.find('.m-sort').val() || '0', 10),
        enabled: tr.find('.m-enabled').val() === 'true'
      };

      if (!m.id) {
        jsonAjax('POST', api('/menus'), body, function () {
          alert('추가 완료'); loadMenus();
        });
      } else {
        jsonAjax('PUT', api('/menus/' + m.id), body, function () {
          alert('저장 완료'); loadMenus();
        });
      }
    });

    const btnDel = $('<button class="btn">삭제</button>').on('click', function () {
      if (!m.id) { tr.remove(); return; }
      if (!confirm('삭제할까요?')) return;
      jsonAjax('DELETE', api('/menus/' + m.id), null, function () {
        alert('삭제 완료'); loadMenus();
      });
    });

    tr.append($('<td/>').append(btnSave).append(' ').append(btnDel));
    return tr;
  }

  function loadBanners() {
    const lang = getLang();
    jsonAjax('GET', api('/banners?lang=' + lang), null, function (res) {
      const tbody = $('#bannerTable tbody').empty();
      (res.data || []).forEach(function (b) { tbody.append(renderBannerRow(b)); });
    });
  }

  function renderBannerRow(b) {
    const tr = $('<tr/>');
    tr.append($('<td/>').text(b.id || ''));

    const typeSel = $('<select class="b-type"><option value="IMAGE">IMAGE</option><option value="YOUTUBE">YOUTUBE</option></select>');
    typeSel.val(b.type || 'IMAGE');
    tr.append($('<td/>').append(typeSel));

    tr.append($('<td/>').append($('<input class="b-title"/>').val(b.title || '')));
    tr.append($('<td/>').append($('<input class="b-image"/>').val(b.imageUrl || '')));
    tr.append($('<td/>').append($('<input class="b-youtube"/>').val(b.youtubeUrl || '')));
    tr.append($('<td/>').append($('<input class="b-link"/>').val(b.linkUrl || '')));
    tr.append($('<td/>').append($('<input class="b-sort" type="number"/>').val(b.sortOrder ?? 0)));

    const enabledSel = $('<select class="b-enabled"><option value="true">true</option><option value="false">false</option></select>');
    enabledSel.val(String(!!b.enabled));
    tr.append($('<td/>').append(enabledSel));

    const btnSave = $('<button class="btn primary">저장</button>').on('click', function () {
      const lang = getLang();
      const body = {
        lang: lang,
        type: tr.find('.b-type').val(),
        title: tr.find('.b-title').val(),
        imageUrl: tr.find('.b-image').val(),
        youtubeUrl: tr.find('.b-youtube').val(),
        linkUrl: tr.find('.b-link').val(),
        sortOrder: parseInt(tr.find('.b-sort').val() || '0', 10),
        enabled: tr.find('.b-enabled').val() === 'true'
      };

      if (!b.id) {
        jsonAjax('POST', api('/banners'), body, function () {
          alert('추가 완료'); loadBanners();
        });
      } else {
        jsonAjax('PUT', api('/banners/' + b.id), body, function () {
          alert('저장 완료'); loadBanners();
        });
      }
    });

    const btnDel = $('<button class="btn">삭제</button>').on('click', function () {
      if (!b.id) { tr.remove(); return; }
      if (!confirm('삭제할까요?')) return;
      jsonAjax('DELETE', api('/banners/' + b.id), null, function () {
        alert('삭제 완료'); loadBanners();
      });
    });

    tr.append($('<td/>').append(btnSave).append(' ').append(btnDel));
    return tr;
  }

  $('#btnReload').on('click', function () { loadLayout(); loadMenus(); loadBanners(); });
  $('#btnSaveLayout').on('click', saveLayout);
  $('#btnAddMenu').on('click', function () {
    $('#menuTable tbody').prepend(renderMenuRow({ id: null, label: '', href: '', sortOrder: 0, enabled: true }));
  });
  $('#btnAddBanner').on('click', function () {
    $('#bannerTable tbody').prepend(renderBannerRow({ id: null, type: 'IMAGE', title: '', imageUrl: '', youtubeUrl: '', linkUrl: '', sortOrder: 0, enabled: true }));
  });

  loadLayout(); loadMenus(); loadBanners();
})();
