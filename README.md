teenage_mutant_ninja_graphs
===========================

Graph various rails data using Raphael and G.Raphael

[<img src="//dl.dropbox.com/s/h9ei52it0dm3cp5/Screen%20Shot%202013-02-05%20at%205.18.11%20PM.png">]


## Installation

Add this line to your application's Gemfile:

    gem 'teenage_mutant_ninja_graphs', :git => "https://github.com/j-mcnally/teenage_mutant_ninja_graphs.git"

And then execute:

    $ bundle


## Usage

*This is a work in progress, so not everything is there, so far my need have been for simple line graphs*

we are able to use it like this. but i haven't tested the api much past it.

    = lineGraph({
        :records => @model.activities, 
        :x => :created_at, 
        :y => :_group_sum_for_x, 
        :grouping => :user_id, 
        :labelProc => Proc.new{|x| User.find(x).full_name rescue x} 
        })



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)

