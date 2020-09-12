<script lang="ts">
  import { fade } from "svelte/transition";
</script>

<style>
  .sampleLink {
    color: #b8392e;
  }
  .welcome {
    max-width: 684px;
    font-size: 105%;
    background-color: #fafafa;
    border: 1px solid rgba(16, 112, 64, 0.4);
    border-radius: 0.25rem;
    padding: 0 1rem 0 1rem;
  }
  .welcome p {
    hyphens: auto;
    line-height: 140%;
  }
  @media (min-width: 1280px) {
    .welcome {
      margin: auto;
    }
  }
</style>

<div class="welcome" in:fade>
  <p>
    Welcome! This is a prototype for a kind of <em>scholar’s rolodex</em>,
    developed using the <a href="https://svelte.dev/">Svelte</a> framework (to use
    the term loosely) with TypeScript.
  </p>

  <p>
    Feel free to play around with this, but it isn’t yet fit for serious use.
    There is no back end, and therefore no persistent data storage. Any contact
    cards that you create will (ideally) be saved as <a
      href="https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage">localStorage</a>
    in your web browser.
  </p>

  <p>
    Using the buttons above, you can add new cards, search in their contents, or
    summon this description again (once there’s something else to display). If
    you’d like to load a set of sample cards, to get a sense of the interface, <a
      href="#sample"
      class="sampleLink">click here</a>.
  </p>

  <p>
    I’m developing this as a way of learning Svelte—the first modern front-end
    framework that I’ve tried and actually enjoyed. My source code is available <a
      href="https://github.com/theodore-s-beers/scholodex">on GitHub</a>.
  </p>
</div>
