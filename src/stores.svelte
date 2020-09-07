<script context="module" lang="ts">
  import { writable } from "svelte/store";

  export const cards = writable([]);
  export const current = writable({
    id: "",
    surname: "",
    givenNames: "",
    affiliations: "",
    fields: "",
    ideas: "",
    email: "",
  });
  export const editing = writable(false);
  export const expanded = writable(false);
  export const resultCards = writable([]);
  export const selectedItem = writable(null);
</script>
