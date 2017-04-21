
# Adopt a Sidewalk
Claim responsibility for shoveling out a sidewalk after it snows.

## <a name="screenshots">Screenshot</a>
![Adopt a Sidewalk](https://github.com/Chicago/adopt-a-sidewalk/raw/master/screenshot.png "Adopt a Sidewalk")

## <a name="demo">Demo</a>
You can see a running version of the application at
[http://adopt.chicagoshovels.org/](http://adopt.chicagoshovels.org/).

## <a name="installation">Installation</a>
    git clone git://github.com/Chicago/adopt-a-sidewalk.git
    cd adopt-a-sidewalk
    bundle install
    
### Prerequisites

* Git
* PostgreSQL with PostGIS extensions enabled
    * Requires geos, gdal and proj.4
* Ruby 1.9.x
* Rubygems
* Bundler

See [EC2 Setup](https://github.com/cfachicago/adopt-a-sidewalk/wiki/EC2-Setup) for a play-by-play setting up a fully-working Adopt-a-Sidewalk on EC2/Ubuntu 12.04.1 using Apache/passenger

### Setting up the database

1. Install PostgreSQL with the PostGIS extensions: e.g. `brew install postgis`
2. Download the chicagosidewalks shape file from the City of Chicago Data Portal http://data.cityofchicago.org
3. Convert the shapefile into PostGIS SQL: `shp2pgsql -s 3435:4326 -g the_geom -I chicagosidewalks.shp >chicagosidewalks.sql`
    * `-s 3435:4326` This converts the geospatial data from the EPSG:3435 (NAD83 / Illinois East) project to ESPG:4326 (WGS84, lat/long)
    * `-g the_geom` name the geocolumn `the_geom` to match what's in the Rails code
    * `-I` generate a spatial index on the geocolumn.
4. Create a database that will host your app: e.g. `createdb adoptasidewalk_dev`
5. Add the PostGIS extensions to your database: e.g. `psql adoptasidewalk_dev -c "CREATE EXTENSION postgis;"`
    * MAGIC
6. Load in `chicagosidewalks.sql`: e.g. `psql adoptasidewalk_dev <chicagosidewalks.sql`
7. Configure `database.yml` to point to your database
8. Run Rails migrations: `rake db:migrate`

### Google Maps KML Endpoint

**tl;dr** Set the environment variable `GMAPS_KML_ENDPOINT` to the address of your publicly-exposed host

This part is tricky. The Rails app is designed so that a client-side call to a Google Maps function loads up KML from HTTP endpoint in the app. What this means is that your running app has to be exposed to the Internet in order to load up the sidewalk KML on the map. This is fine in production, but in development (read: on your laptop, etc) you're likely behind a firewall and Google will be unable to load the KML.

One solution to this problem is to use SSH Remote Forwarding.

1. Have an Internet exposed Linux Server (e.g. AWS instance)
2. Configure sshd to have "GatewayPorts yes"
3. On development machine create a remote forward connection: ssh -nNTR *:3000:localhost:3000 your.remote.server.com
4. Set `GMAPS_KML_ENDPOINT` to "your.remote.server.com:3000"
    * `GMAPS_KML_ENDPOINT=your.remote.server.com:3000 rails s`
    * `export GMAPS_KML_ENDPOINT=your.remote.server.com:3000; rails s`
    * Use foremen and .env (http://ddollar.github.com/foreman/#ENVIRONMENT)

In production, this is likely the hostname or IP of your production server.

## <a name="usage">Usage</a>
    rails server

## <a name="contributing">Contributing</a>
In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by reviewing patches

## <a name="issues">Submitting an Issue</a>
We use the [GitHub issue tracker](https://github.com/Chicago/adopt-a-sidewalk/issues) to track bugs and
features. Before submitting a bug report or feature request, check to make sure it hasn't already
been submitted. You can indicate support for an existing issuse by voting it up. When submitting a
bug report, please include a [Gist](https://gist.github.com/) that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version, Ruby version, and
operating system. Ideally, a bug report should include a pull request with failing specs.

## <a name="pulls">Submitting a Pull Request</a>
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add tests for your feature or bug fix.
5. Run <tt>bundle exec rake test</tt>. If your changes are not 100% covered, go back to step 4.
6. Commit and push your changes.
7. Submit a pull request. Please do not include changes to the gemspec or version file. (If you want to create your own version for some reason, please do so in a separate commit.)

## <a name="rubies">Supported Rubies</a>

* Ruby 1.9.3

If something doesn't work on one of these interpreters, it should be considered
a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.
