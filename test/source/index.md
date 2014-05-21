---
layout: theme:test
title: Your New Jekyll Site
---

Test plugin assets and overrides:

- stylesheets
- javascripts
- files
- images
- fonts
- sass plugin

Test configurations

- sass compression
- sass line numbers
- combine_css
- combine_js

{% assign separator = ' <span class='separator'></b> ' %}
{% capture foo | join_lines:separator %}
one
 two
 three

four five

{% endcapture %}{{ foo }}
