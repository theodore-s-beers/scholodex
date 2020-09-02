<script context="module" lang="ts">
  import { v4 as uuidv4 } from "uuid";

  export interface ContactCard {
    id: string;
    surname: string;
    givenNames: string;
    affiliations: string[];
    fields: string[];
    email: string;
  }

  export const sampleCards: ContactCard[] = [
    {
      id: uuidv4(),
      surname: "Woods",
      givenNames: "John E.",
      affiliations: ["University of Chicago"],
      fields: ["Iranian History", "Central Asian History"],
      email: "j-woods@uchicago.edu",
    },
    {
      id: uuidv4(),
      surname: "Gründler",
      givenNames: "Beatrice",
      affiliations: ["Freie Universität Berlin", "Yale University"],
      fields: ["Arabic Literature"],
      email: "beatrice.gruendler@fu-berlin.de",
    },
    {
      id: uuidv4(),
      surname: "Cook",
      givenNames: "Michael A.",
      affiliations: ["Princeton University"],
      fields: ["Islamicate History"],
      email: "mcook@princeton.edu",
    },
    {
      id: uuidv4(),
      surname: "Lewis",
      givenNames: "Franklin D.",
      affiliations: ["University of Chicago"],
      fields: ["Persian Literature", "Islamic Studies"],
      email: "flewis@uchicago.edu",
    },
    {
      id: uuidv4(),
      surname: "Blankinship",
      givenNames: "Kevin",
      affiliations: ["Brigham Young University", "University of Chicago"],
      fields: ["Arabic Literature"],
      email: "kevin_blankinship@byu.edu",
    },
    {
      id: uuidv4(),
      surname: "Beers",
      givenNames: "Theodore S.",
      affiliations: ["Freie Universität Berlin", "University of Chicago"],
      fields: ["Persian Literature", "Iranian History"],
      email: "theo.beers@fu-berlin.de",
    },
  ];

  export function complexCompare(a: ContactCard, b: ContactCard) {
    if (a.surname === b.surname) {
      return a.givenNames.localeCompare(b.givenNames);
    } else {
      return a.surname.localeCompare(b.surname);
    }
  }
</script>
