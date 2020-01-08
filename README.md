# racing_snakes
<i>Eat the food and destroy your enemies!</i>
<h1>About</h1>
<p>A two-player spin on the snake game, written in <a href="https://www.ruby2d.com/">ruby 2d</a> framework and initial snake mechanics taken from Mario Visic's <a href ="https://www.youtube.com/watch?v=2UVhYHBT_1o">tutorial</a></p>
<h1>To Play</h1>
<p>You'll need to install <a href="https://www.ruby-lang.org/en/documentation/installation/">ruby</a> and the <a href="https://www.ruby2d.com/learn/get-started/">ruby 2d</a> gem. Then you'll want to clone or download the source to your local. Go ahead and run the program with...</p>
<code>ruby racing_snakes.rb</cold>
<h2>The rules</h2>
<p1>A game for two players: Move your snake with either W, S, A, D keys or the arrow keys. Eat the snake food to grow. The first snake to crash loses. Two snakes colliding directly head-on counts as a tie. Press space to pause and esc to close.</p1>
<h1>Changes Made</h1>
<p>Mario Visic's <a href ="https://www.youtube.com/watch?v=2UVhYHBT_1o">tutorial</a> was very helpful in creating snake and game classes, and managing the snake objects growth, movement and collision detection via an array of tile coordinates. I've made the following changes from Mario's tutorial:
  <ul>
    <li>Two snakes that interact with each other</li>
    <li>Food will not spawn in space occumpied by a snake</li>
    <li>Gameplay change: only one turn per clock tick</li>
    <li>Food respawns after 15 - 20 seconds of inactivity</li>
    <li>Randomized colors for snakes and graphical embellishments</li>
    <li>a pause button</li>
</ul>
<p>That's my snake game. Race and fight for the users.</p>
