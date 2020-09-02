<script context="module" lang="ts">
  import { writable } from "svelte/store";

  export const cards = writable([]);
  export const current = writable({
    id: "",
    surname: "",
    givenNames: "",
    affiliations: [],
    fields: [],
    email: "",
  });
  export const editing = writable(false);
  export const selectedItem = writable(null);
</script>
