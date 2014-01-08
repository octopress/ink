---
layout: theme:default
title: Your New Jekyll Site
---

Test plugin assets and overrides:

- layouts
- includes
- stylesheets
- javascripts
- files
- images
- fonts
- sass plugin

Test configurations

- sass compression
- sass line numbers
- concat_css
- concat_js

Test: markdown
**Hello World!**

Test: head tag
{% head %}
{% include theme:foo.html greeting='Yo Dawg' %}
{% endhead %}

{% content_for footer %}
**OMG**
{% endcontent_for %}

{% include foo.html some_var='booga' %}
