<script lang="ts">
  import { onMount } from "svelte";
  import { fade } from "svelte/transition";
  import { v4 as uuidv4 } from "uuid";
  import { cards, current, editing, selectedItem } from "./stores.svelte";

  export let affiliations: string;
  export let email = "";
  export let fields: string;
  export let givenNames = "";
  export let ideas: string;
  export let surname = "";

  let affiliationOne = affiliations.toString().split(",")[0];
  let affiliationTwo = affiliations.toString().split(",")[1];

  let fieldOne = fields.toString().split(",")[0];
  let fieldTwo = fields.toString().split(",")[1];

  let ideaOne = ideas.toString().split(",")[0];
  let ideaTwo = ideas.toString().split(",")[1];
  let ideaThree = ideas.toString().split(",")[2];

  let surnameField: HTMLInputElement;

  const newId = uuidv4();

  function backHome() {
    // If this was for an edit
    if ($current.id) {
      $current = {
        id: "",
        surname: "",
        givenNames: "",
        affiliations: "",
        fields: "",
        ideas: "",
        email: "",
      };
      $editing = false;
    } else {
      // If this was for a new card
      $editing = false;
      window.location.hash = "home";
    }
  }

  function deleteOld() {
    const deprecated = $cards.find((x) => x.id === $current.id);
    if (deprecated === undefined) {
      console.log("Something went very wrong...");
    } else {
      const deprecatedIndex = $cards.indexOf(deprecated);
      $cards = $cards
        .slice(0, deprecatedIndex)
        .concat($cards.slice(deprecatedIndex + 1));
    }
  }

  function generateCard() {
    if (
      !surname ||
      !givenNames ||
      !affiliationOne ||
      !fieldOne ||
      !ideaOne ||
      !email
    ) {
      alert("Please fill in all required fields, or cancel.");
    } else {
      $cards = $cards.concat({
        id: newId,
        surname: sanitize(surname),
        givenNames: sanitize(givenNames),
        affiliations: affiliationTwo
          ? sanitize(affiliationOne) + "," + sanitize(affiliationTwo)
          : sanitize(affiliationOne),
        fields: fieldTwo
          ? sanitize(fieldOne) + "," + sanitize(fieldTwo)
          : sanitize(fieldOne),
        ideas:
          ideaTwo && ideaThree
            ? sanitize(ideaOne) +
              "," +
              sanitize(ideaTwo) +
              "," +
              sanitize(ideaThree)
            : ideaThree
            ? sanitize(ideaOne) + "," + sanitize(ideaThree)
            : ideaTwo
            ? sanitize(ideaOne) + "," + sanitize(ideaTwo)
            : sanitize(ideaOne),
        email: sanitize(email),
      });
      if ($current.id) {
        deleteOld();
        const newItem = $cards.find((x) => x.id === newId);
        if (newItem === undefined) {
          console.log("Something went very wrong...");
        } else {
          $selectedItem = newItem;
          window.location.hash = $selectedItem.id;
        }
      }
      backHome();
    }
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === "Enter") {
      generateCard();
    } else if (event.key === "Escape" || event.key === "Esc") {
      backHome();
    } else {
      return;
    }
  }

  function sanitize(input: string) {
    const disallowed = /[",]/g;
    return input.replace(disallowed, "").trim();
  }

  onMount(() => {
    if (!surname) {
      surnameField.focus();
    }
  });
</script>

<div class="detail" on:keydown={handleKeydown} in:fade>
  <div class="doubleRow">
    <input
      bind:value={surname}
      bind:this={surnameField}
      placeholder="Surname"
    /><input bind:value={givenNames} placeholder="Name(s)" />
  </div>
  <div class="singleRow">
    <input bind:value={affiliationOne} placeholder="Affiliation 1" />
  </div>
  <div class="singleRow">
    <input bind:value={affiliationTwo} placeholder="Affiliation 2 (optional)" />
  </div>
  <div class="singleRow">
    <input bind:value={fieldOne} placeholder="Field 1" />
  </div>
  <div class="singleRow">
    <input bind:value={fieldTwo} placeholder="Field 2 (optional)" />
  </div>
  <div class="singleRow">
    <input bind:value={ideaOne} placeholder="Key idea 1" />
  </div>
  <div class="singleRow">
    <input bind:value={ideaTwo} placeholder="Key idea 2 (optional)" />
  </div>
  <div class="singleRow">
    <input bind:value={ideaThree} placeholder="Key idea 3 (optional)" />
  </div>
  <div class="singleRow"><input bind:value={email} placeholder="Email" /></div>
  <div class="buttonsRow">
    <button class="submitButton" on:click={generateCard}>Submit</button><button
      on:click={backHome}>Cancel</button
    >
  </div>
</div>

<style>
  button,
  input {
    padding: 0.5rem;
  }
  .buttonsRow {
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
  }
  .detail {
    background-color: #fafafa;
    width: 300px;
    border: 1px solid rgba(16, 112, 64, 0.4);
    border-radius: 0.25rem;
    padding: 1rem;
    margin: auto;
    display: flex;
    flex-flow: column nowrap;
  }
  .doubleRow {
    display: flex;
    flex-flow: row nowrap;
    justify-content: space-between;
    margin-bottom: 1rem;
  }
  .doubleRow input {
    width: 47.5%;
  }
  .singleRow {
    margin-bottom: 1rem;
  }
  .singleRow input {
    width: 100%;
  }
  .submitButton {
    margin-right: 1rem;
  }
</style>
