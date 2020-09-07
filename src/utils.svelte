<script context="module" lang="ts">
  import { v4 as uuidv4 } from "uuid";

  interface ContactCard {
    id: string;
    surname: string;
    givenNames: string;
    affiliations: string;
    fields: string;
    ideas: string;
    email: string;
  }

  export const sampleCards: ContactCard[] = [
    {
      id: uuidv4(),
      surname: "Woods",
      givenNames: "John E.",
      affiliations: "University of Chicago",
      fields: "Iranian History,Central Asian History",
      ideas: "Aqquyunlu,Confessional ambiguity",
      email: "j-woods@uchicago.edu",
    },
    {
      id: uuidv4(),
      surname: "Gründler",
      givenNames: "Beatrice",
      affiliations: "Freie Universität Berlin,Yale University",
      fields: "Arabic Literature",
      ideas: "Development of Arabic script,Rise of the Arabic book",
      email: "beatrice.gruendler@fu-berlin.de",
    },
    {
      id: uuidv4(),
      surname: "Cook",
      givenNames: "Michael A.",
      affiliations: "Princeton University",
      fields: "Islamicate History",
      ideas: "Commanding right and forbidding wrong,Hagarism",
      email: "mcook@princeton.edu",
    },
    {
      id: uuidv4(),
      surname: "Lewis",
      givenNames: "Franklin D.",
      affiliations: "University of Chicago",
      fields: "Persian Literature,Islamic Studies",
      ideas: "Mawlana Rumi,History of the ghazal",
      email: "flewis@uchicago.edu",
    },
    {
      id: uuidv4(),
      surname: "Blankinship",
      givenNames: "Kevin",
      affiliations: "Brigham Young University,University of Chicago",
      fields: "Arabic Literature",
      ideas: "al-Ma‘arri,Maghribi poetry",
      email: "kevin_blankinship@byu.edu",
    },
    {
      id: uuidv4(),
      surname: "Beers",
      givenNames: "Theodore S.",
      affiliations: "Freie Universität Berlin,University of Chicago",
      fields: "Persian Literature,Iranian History",
      ideas: "History of tazkirahs",
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

  export function searchCards(cards: ContactCard[], needle: string) {
    const needleNormalized = needle.trim().toLowerCase();
    let results: number[] = [];
    for (let i = 0; i < cards.length; i++) {
      for (let key in cards[i]) {
        if (key !== "id") {
          if (cards[i][key].toLowerCase().indexOf(needleNormalized) !== -1) {
            results.push(i);
            break;
          }
        }
      }
    }
    return results;
  }
</script>
