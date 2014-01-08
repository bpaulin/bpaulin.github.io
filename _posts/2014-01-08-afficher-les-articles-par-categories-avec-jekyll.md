---
layout:     post
title:      Afficher les articles par categories avec Jekyll
categories: jekyll
---

Le code utilisé pour la page [article](/articles/) pour afficher les articles classés par catégories

{% highlight smarty %}
{% raw %}
{% for category in site.categories %}
    <h2 id="{{ category | first }}">{{ category | first | capitalize }}</h2>
    {% for post in category[1] %}
        <ul class="list-unstyled">
            <li>
                <a href="{{ post.url }}">
                    {{ post.title }}
                </a>
            </li>
        </ul>
    {% endfor %}
{% endfor %}
{% endraw %}
{% endhighlight %}