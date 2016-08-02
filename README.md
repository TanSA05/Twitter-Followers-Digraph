# Twitter-Followers-Digraph
A ruby script to generate a digraph for Twitter followers, with separate node points for common nodes. There are two scripts:

* Script 1 `twitter_digraph.rb` handles at max 10 users and max 200 followers for each user. (You will need to wait for 45mins - 1hr for this to run successfully with one key. Minimum 4 keys are required for this program to run successfully in one go. It will take around 10 mins - decreases as the number of keys increases)
* Script 2 `twitter_small_digraph.rb` handles at max 8 users and max 25 followers for each user. (Faster to run and requires only one key)


# Pre-requisites
* `ruby-2.1.4` for `twitter_digraph.rb` and `ruby-1.9.3` for `twitter_small_digraph.rb`
* Two gems in both versions of ruby - `twitter` and `gchartrb` (Run `gem install gem_name` for both)

# Executing The Script
* `ruby twitter_digraph.rb Username1 Username2 .. Username10`
* `ruby twitter_small_digraph.rb Username1 Username2 ... Username 8`

After the script runs succesfully, a `dot` file will be generated in the same directory. To generate the digraph, run the following commands:

* `circo graph.dot -Tpng -o graph.png`
* `circo graph_small.dot -Tpng -o graph_small.png`

# Resources
* http://www.ibm.com/developerworks/library/os-dataminingrubytwitter/#list11
* Twitter REST API
