<script lang="ts">
  import { onMount } from "svelte";
  import { fade } from "svelte/transition";
  import { v4 as uuidv4 } from "uuid";
  import { cards, current, editing, selectedItem } from "./stores.svelte";

  export let affiliationOne: string = "";
  export let affiliationTwo: string = "";
  export let email: string = "";
  export let fieldOne: string = "";
  export let fieldTwo: string = "";
  export let fieldThree: string = "";
  export let givenNames: string = "";
  export let surname: string = "";

  const newId = uuidv4();

  function generateCard() {
    if (!surname || !givenNames || !affiliationOne || !fieldOne || !email) {
      alert("Please fill in all required fields, or cancel.");
    } else {
      $cards = $cards.concat({
        id: newId,
        surname: surname,
        givenNames: givenNames,
        affiliations: affiliationTwo
          ? [affiliationOne, affiliationTwo]
          : [affiliationOne],
        fields:
          !fieldTwo && !fieldThree
            ? [fieldOne]
            : [fieldOne, fieldTwo, fieldThree].filter((x) => x.length > 0),
        email: email,
      });
      if ($current.id) {
        deleteOld();
        $selectedItem = $cards.find((x) => x.id === newId);
      }
      backHome();
    }
  }

  function deleteOld() {
    let deprecated = $cards.find((x) => x.id === $current.id);
    let deprecatedIndex = $cards.indexOf(deprecated);
    $cards = $cards
      .slice(0, deprecatedIndex)
      .concat($cards.slice(deprecatedIndex + 1));
  }

  function backHome() {
    if (!$current.id) {
      $selectedItem = null;
    }
    $current = {
      id: "",
      surname: "",
      givenNames: "",
      affiliations: [],
      fields: [],
      email: "",
    };
    $editing = false;
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

  let surnameField: HTMLInputElement;

  onMount(() => {
    if (!surname) {
      surnameField.focus();
    }
  });
</script>

<style>
  .buttonsRow {
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
  }
  .detail {
    width: 300px;
    border: 1px solid #aaa;
    border-radius: 0.25em;
    box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.1);
    padding: 1em;
    display: flex;
    flex-flow: column nowrap;
    margin: auto;
  }
  .doubleRow {
    display: flex;
    flex-flow: row wrap;
    justify-content: space-between;
    margin-bottom: 0.5em;
  }
  .doubleRow input {
    width: 48%;
  }
  .singleRow {
    margin-bottom: 0.5em;
  }
  .singleRow input {
    width: 100%;
  }
  .submitButton {
    margin-right: 1em;
  }
</style>

<div class="detail" on:keydown={handleKeydown} in:fade>
  <div class="doubleRow">
    <input
      bind:value={surname}
      bind:this={surnameField}
      placeholder="Surname" /><input
      bind:value={givenNames}
      placeholder="Name(s)" />
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
    <input bind:value={fieldThree} placeholder="Field 3 (optional)" />
  </div>
  <div class="singleRow"><input bind:value={email} placeholder="Email" /></div>
  <div class="buttonsRow">
    <button class="submitButton" on:click={generateCard}>Submit</button><button on:click={backHome}>Cancel</button>
  </div>
</div>
