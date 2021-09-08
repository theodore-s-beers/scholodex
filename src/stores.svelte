<script context="module" lang="ts">
  import { writable } from "svelte/store";
  import type { ContactCard } from "./utils.svelte";

  const emptyCardArray: ContactCard[] = [];
  const emptyCard: ContactCard = {
    id: "",
    surname: "",
    givenNames: "",
    affiliations: "",
    fields: "",
    ideas: "",
    email: "",
  };

  export const about = writable(false);
  export const cards = writable(emptyCardArray);
  export const current = writable(emptyCard);
  export const editing = writable(false);
  export const expanded = writable(false);
  export const resultCards = writable(emptyCardArray);
  export const selectedItem = writable(emptyCard);
</script>
