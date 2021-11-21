---
layout: default
---
<section class="text-gray-400 bg-gray-900 body-font">
    <div class="container px-5 py-24 mx-auto">

        <div class="flex flex-col">
            <div class="h-1 bg-gray-800 rounded overflow-hidden">
                <div class="w-24 h-full bg-indigo-400"></div>
            </div>
            <div class="flex flex-wrap sm:flex-row flex-col py-6 mb-12">
                <h1 class="sm:w-2/5 text-white font-medium title-font text-2xl mb-2 sm:mb-0">Actions</h1>
                <p class="sm:w-3/5 leading-relaxed text-base sm:pl-10 pl-0"></p>
            </div>
        </div>

        <div class="flex flex-wrap -m-2">
            {% for action in site.actions %}
            <div class="p-2 lg:w-1/3 md:w-1/2 w-full">
                <div class="h-full flex border-gray-800 border p-4 rounded-lg">

                    <div class="flex-grow">
                        <h2 class="text-white title-font font-medium"><a href="{{ action.url }}"> {{ action.name }}</a></h2>
                        {% if action.author %}                        
                        <p class="leading-relaxed text-xs">By {{action.author }}</p>
                        {% endif %}
                        {{action.description}}
                    </div>

                </div>
            </div>
            {% endfor %}
        </div>

    </div>
</section>