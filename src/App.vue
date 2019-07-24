<template>
  <div id="app" class="container">
    <header>
        <img alt="Vue logo" src="./assets/logo.png" />
    </header>

    <hr />

    <Home />
  </div>
</template>

<script>
import Home from "./components/Home.vue";

export default {
  name: "app",
  components: {
    Home
  }
};
</script>
