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
      surname: "Blankinship",
      givenNames: "Kevin",
      affiliations: "Brigham Young University,University of Chicago",
      fields: "Arabic Literature",
      ideas: "al-Ma‘arri,Maghribi poetry",
      email: "kevin_blankinship@byu.edu",
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
      surname: "Fleischer",
      givenNames: "Cornell H.",
      affiliations: "University of Chicago",
      fields: "Ottoman History,Intellectual History",
      ideas: "Gelibolu Mustafa Âli,Reign of Süleyman",
      email: "c-fleischer@uchicago.edu",
    },
    {
      id: uuidv4(),
      surname: "Gründler",
      givenNames: "Beatrice",
      affiliations: "Freie Universität Berlin,Yale University",
      fields: "Arabic Literature",
      ideas: "Development of Arabic scripts,Rise of the Arabic book",
      email: "beatrice.gruendler@fu-berlin.de",
    },
    {
      id: uuidv4(),
      surname: "Keegan",
      givenNames: "Matthew L.",
      affiliations: "Barnard College",
      fields: "Arabic Literature",
      ideas: "Maqamat of al-Hariri,Colonial economy of theory",
      email: "mlkeegan@barnard.edu",
    },
    {
      id: uuidv4(),
      surname: "Lewis",
      givenNames: "Franklin D.",
      affiliations: "University of Chicago",
      fields: "Persian Literature,Islamic Studies",
      ideas: "Reception of Mawlana Rumi,Evolution of the ghazal",
      email: "flewis@uchicago.edu",
    },
    {
      id: uuidv4(),
      surname: "Quinn",
      givenNames: "Sholeh A.",
      affiliations: "Univ. of California Merced",
      fields: "Iranian History",
      ideas: "Safavid historiography,Shah ‘Abbas",
      email: "squinn@ucmerced.edu",
    },
    {
      id: uuidv4(),
      surname: "Qutbuddin",
      givenNames: "B. Tahera",
      affiliations: "University of Chicago",
      fields: "Arabic Literature,Islamic Studies",
      ideas: "Islamic sermons (khutbah),Isma‘ili da‘wah poetry",
      email: "btq@uchicago.edu",
    },
    {
      id: uuidv4(),
      surname: "Stephan",
      givenNames: "Johannes",
      affiliations: "Freie Universität Berlin",
      fields: "Arabic Literature",
      ideas: "Middle Arabic,Hanna Diyab",
      email: "johannes.stephan@fu-berlin.de",
    },
    {
      id: uuidv4(),
      surname: "Toral",
      givenNames: "Isabel",
      affiliations: "Freie Universität Berlin",
      fields: "Arabic Literature,Byzantine Studies",
      ideas: "al-Hira,Arabic translation from Greek",
      email: "itoral@zedat.fu-berlin.de",
    },
    {
      id: uuidv4(),
      surname: "van Ginkel",
      givenNames: "Jan J.",
      affiliations: "Freie Universität Berlin",
      fields: "Syriac Studies",
      ideas: "Syriac historiography,Michael the Great",
      email: "jan.van.ginkel@fu-berlin.de",
    },
    {
      id: uuidv4(),
      surname: "Woods",
      givenNames: "John E.",
      affiliations: "University of Chicago",
      fields: "Iranian History,Central Asian History",
      ideas: "Aqquyunlu confederation,Confessional ambiguity",
      email: "j-woods@uchicago.edu",
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
