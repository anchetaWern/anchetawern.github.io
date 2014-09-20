---
layout: post
title: "Using Datatables with Laravel"
date: 2014-08-10 16:48
comments: true
categories: [datatables, php, laravel, jquery]
published: true
---

In this tutorial I'll be walking you through how you can use datatables in Laravel. But first, let me give you a quick intro on what Datatabes is. [Datatables](http://datatables.net/) is basically a jQuery plugin that allows you to add advanced interaction controls to your HTML tables. Things like search, pagination, sorting, and ordering. Datatables allows you to add those kinds of functionality into your tables with minimal code. 


In this tutorial were going to be using a Laravel package called [Chumper](https://github.com/Chumper/Datatable). Chumper allows us to easily create Datatables which uses the data returned from a model as its data source. 

First thing that you need to do is to add the following in your `composer.json` file:

```
"require": {
	"chumper/datatable": "2.*",
}
```

If you got other packages that you need for your project, just add it on the last part of the `require` item. Once you're done with that, execute `composer update` from your terminal to install Chumper.

Once composer finishes installing Chumper, add the service provider for Chumper into the `providers` array in your `app.php` file inside the `app/config` directory of your Laravel installation:

```
'Chumper\Datatable\DatatableServiceProvider',
```

Still inside the `app.php` file, also add the following under the aliases array:

```
'Datatable' => 'Chumper\Datatable\Facades\DatatableFacade',
```

Once that's done, you can now create the main configuration file by executing the following from the terminal:

```
php artisan config:publish chumper/datatable
```

The main configuration file is stored under `app/config/packages/chumper/datatable/config.php` so go ahead and edit that if you want to change the default settings provided by Chumper. Things like the class or ID given to the tables generated can be configured from that file. This is particularly useful if you want to use classes or IDs to style the datatables in a specific way. Other than that the default settings can be used for most cases.

Now that we have configured Chumper, we can now add a route that will return the page where the datatable is displayed in your `routes.php` file. In the example below, we have the a controller called `AdminController` and were using the data returned by the `users` method as a response whenever the `users` route is accessed via the `GET` method: 

``` php
<?php
Route::get('users', 'AdminController@users');
?>
```

Next we also need to add the route that will return the data into the client side. By default, Chumper uses the server for processing queries made through the datatable. This means that it only gets the actual data that is needed instead of getting all of the records in the database table that you specify. In the code below, were giving a name of `api.users` to the `api/users` route so that we can refer to it later in the controller. The `uses` keyword allows you to specify a controller action to the route. Its basically the same thing as what we did above but that's the way to do it if you're using named routes. 

```
<?php
Route::get('api/users', array('as' => 'api.users', 'uses' => 'AdminController@getUsersDataTable'));
?>
```


Under your controller, here's the method that returns the page where the datatable is displayed:

```
<?php
public function users(){

    $table = Datatable::table()
    	->addColumn('Name', 'Last Login', 'View')
    	->setUrl(route('api.users'))
    	->noScript();

    $this->layout->content = View::make('admin.users', array('table' => $table));
}
?>
```

The code above assumes that you're using [Laravel layouts](http://laravel.com/docs/templates). If you don't know how to use layouts in Laravel, be sure to check out the docs. Breaking the code down, the following code allows you create the datatable. You can add columns to it by using the `addColumn` method. This method takes up the names that you want to give to the header for each field in the table. The `setUrl` method allows you to set the route that the datatable will use for processing queries made through it. Earlier we created a route and named it `api.users` so in the `setUrl` method all we have to do is to use the `route` method and then supply the name of the route which is responsible for returning the data for processing the queries. Lastly, we call the `noScript()` method to specify that we don't want to add the JavaScript code in the response that will be returned.

```
<?php
$table = Datatable::table()
	->addColumn('Name', 'Last Login', 'View')
	->setUrl(route('api.users'))
	->noScript();
?>
```

Next is the method which processes the queries made through the datatable:

```
<?php
public function getUsersDataTable(){

    $query = User::select('name', 'active', 'last_login', 'id')->get();

    return Datatable::collection($query)
        ->addColumn('last_login', function($model){
            return date('M j, Y h:i A', strtotime($model->last_login));
        })
        ->addColumn('id', function($model){
            return '<a href="/users/' . $model->id . '">view</a>';
        })
        ->searchColumns('name', 'last_login')
        ->orderColumns('name', 'last_login')
        ->make();
}
?>
```

Breaking it down, the code below allows you to specify the fields that you want to use for the response. These are the actual field names in your database table:

```
<?php
$query = User::select('name', 'last_login', 'id')->get();
?>
```

Next, we return the actual data using the `collection` method in the `Datatable` class. Well, not actually the `Datatable` class, since its just the Facade that we used earlier in the `app.php` file. The `collection` method requires the result set returned by our query to the users table earlier so we just set that as the argument. After that, we can call the `addColumn` method to update the presentation of the data returned for that specific field. In the case of the `last_login` field, its stored in the database as a time stamp which looks like this: `2014-07-29 11:37:39`. We don't really want to present that to the user like that so we format it using the `date` method. The first argument is the format that you want. In this case we want something like this: `Jul 29, 2014 11:37 AM`. Looking at the [official docs](http://php.net/manual/en/function.date.php), we know that we can do that by specifying the following: `M j, Y h:i A`. The second argument is a unix timestamp. We can convert the raw data that came from the database into a unix timestamp by using the `strtotime` method, so we do just that. Next is the `id` field. We don't actually want to display the users id to the user, what we want is to display a link that would lead the user to the page where more details for the user can be viewed. Thus we return an HTML anchor tag which uses the id as one of the component for the actual link.

```
<?php
return Datatable::collection($query)
    ->addColumn('last_login', function($model){
        return date('M j, Y h:i A', strtotime($model->last_login));
    })
    ->addColumn('id', function($model){
        return '<a href="/users/' . $model->id . '">view</a>';
    })
?>
```

Lastly, we can now display the datatable in our view. If you're using [Twitter Bootstrap](http://getbootstrap.com/), it should look similar to this one:

{% raw %}
``` html
@section('content')

<div class="row">
  <div class="col-md-12">
  <h3>Users</h3>
  {{ $table->render() }}
  {{ $table->script() }}
  </div>
</div>
@stop
```
{% endraw %}

Yup! as simple as that! All we have to do is to call the `render()` method to render the actual datatabase. And then we also call the `script()` method to render the JavaScript file that would do the talking to the server every time the user interacts with the table. 
