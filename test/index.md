---
layout: theme:default
title: Your New Jekyll Site
---
**Hello World!**

{% head %}
{% embed theme/foo.html greeting='Yo Dawg' %}
{% endhead %}

{% content_for footer %}
**OMG**
{% endcontent_for %}
