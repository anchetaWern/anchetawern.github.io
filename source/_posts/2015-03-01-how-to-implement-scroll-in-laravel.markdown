---
layout: post
title: "How to Implement Infinite Scroll in Laravel"
date: 2015-03-01 14:39
comments: true
published: true
categories: [laravel, infinite-scroll, quick-tip]
---

In this quick tip I'll be showing you how to easily implement infinite scroll in laravel. In the back-end, we will be using laravel's pagination functionality. And in the front-end, we'll be using [jQuery infinite scroll](https://github.com/infinite-scroll/infinite-scroll). You can ahead and download the jquery.infinitescroll.min.js file from that page and save it on your project directory.

First thing that you need to do is return the data that you want to infinitely scroll from the controller:

```php
<?php
public function getNewsPage(){
    $date = date('Y-m-d');
    $news = News::where('date', '=', $date)->paginate(10);
    $page_data = array(
        'news' => $news
    );
    return View::make('news', $page_data);
} 
?>
```

And then from your view file (`news.blade.php`) just loop through the items that you wish to output:

```html
<div id="news">
    <ul id="items">             
    @foreach($news as $item)
        <li class="item">
            <a href="{{ $item->url }}" target="_blank">{{ $item->title }}</a>
        </li>
    @endforeach
    {{ $news->links() }}
    </ul>
</div>
```

Be sure to include jquery and jquery.infinitescroll.min.js file before the closing body tag:

```html
<script src="{{ asset('assets/js/jquery.min.js') }}"></script>
<script src="{{ asset('assets/js/jquery.infinitescroll.min.js') }}"></script>
</body>
```

Next, create the javascript file that will call the infinitescroll plugin and add the following code:

```javascript
(function(){

    var loading_options = {
        finishedMsg: "<div class='end-msg'>Congratulations! You've reached the end of the internet</div>",
        msgText: "<div class='center'>Loading news items...</div>",
        img: "/assets/img/ajax-loader.gif"
    };

    $('#items').infinitescroll({
      loading : loading_options,
      navSelector : "#news .pagination",
      nextSelector : "#news .pagination li.active + li a",
      itemSelector : "#items li.item"
    });
})();
```

Breaking it down. First we wrap everything in a self-executing anonymous function to make sure that the script that were writing won't have a way of messing up with the other scripts in our page, if any. Next, we setup options required by infinite scroll by means of a JavaScript object. Here's a brief description of each:

- `finishedMsg` - the html or text that you want to show once the user has reached the last page.
- `msgText` - the text that you want to show while the next page is being loaded from the back-end.
- `img` - the image that you want to show while the next page is being loaded from the back-end. Usually this is a gif animation that indicates that something is happening.

Next we call the infinitescroll plugin on the main news wrapper. This takes up an object as its argument. The object contains the following items:

- `loading` - the loading options that we have setup earlier.
- `navSelector` - the jquery selector that targets the pagination wrapper. Laravel gives it a class of `pagination` by default.
- `nextSelector` - the element indicating the next page. Laravel adds the `active` class on the `li` representing the current page. So all we need to do is to traverse to the next one by using the `+` selector and then the anchor element. 
- `itemSelector` - an individual item. 


###Conclusion

That's it for this quick tip. With the jquery infinite scroll plugin and laravel's pagination functionality, you can implement infinite scroll in your apps with ease.

