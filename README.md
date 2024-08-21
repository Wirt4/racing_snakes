# racing_snakes
<i>Eat the food and destroy your enemies!</i>
<h1>About</h1>
<p>A two-player spin on the snake game, written in <a href="https://www.ruby2d.com/">ruby 2d</a> framework and initial snake mechanics taken from Mario Visic's <a href ="https://www.youtube.com/watch?v=2UVhYHBT_1o">tutorial</a></p>
<h1>Setup</h1>
<p>
<h2>Assumptions</h2>
<ul>
<li>You're running MacOS or Linux</li>
<li>You're conversant with Ruby and Ruby Gems</li>
</ul>
<h2>Requirements</h2>
<ol>
<li>Install a manager for ruby (I use <code>rbenv</code>)</li>
<li>Install the latest stable version of Ruby (<code>rbenv install 3.4.3</code>)</li>
<li>Make sure you can use the latest version (I got lazy and set it to global <code>rbenv global 3.4.3</code>)</li>
<li>install the gem ruby 2d <code>gem install ruby2d</code> (you may need to use <code>sudo</code>)</li>
</ol>
</p>

<h1>To Play</h1>
<p>Run the followoing to start the app</p>
<code>ruby racing_snakes.rb</cold>
<h2>The rules</h2>
<p>A game for two players: Move your snake with either W, D keys or O,P keys. The left key turns  your snake had anticlockwise. Right turns your snake head clockwise. Eat the snake food to grow. The first snake to crash loses. Two snakes colliding directly head-on counts as a tie. Press space to pause and esc to close.</p>
<h1>Changes Made</h1>
<p>Mario Visic's <a href ="https://www.youtube.com/watch?v=2UVhYHBT_1o">tutorial</a> was very helpful in creating snake and game classes, and managing the snake objects growth, movement and collision detection via an array of tile coordinates. I've made the following changes from Mario's tutorial:
  <ul>
    <li>Two snakes that interact with each other</li>
    <li>Food will not spawn in space occumpied by a snake</li>
    <li>Gameplay change: only one turn per clock tick</li>
    <li>Food respawns after 15 - 20 seconds of inactivity</li>
    <li>Randomized colors for snakes and graphical embellishments</li>
    <li>a pause button (space bar)</li>
</ul>
<h1>To Test</h1>
<p>`rspec Tests/*`</p>