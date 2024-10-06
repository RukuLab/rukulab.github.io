import { defineConfig } from "vocs";

export default defineConfig({
  title: "Ruku",
  logoUrl: '/logo.svg',
  description:
    "A rust based tiny PaaS. \
    Ruku allows you to do git push deployments to your own servers. ",
  sidebar: [
    {
      text: "Getting Started",
      link: "/getting-started",
    },
    {
      text: "Example",
      link: "/example",
    },
  ],
  socials: [
    {
      icon: 'github',
      link: 'https://github.com/RukuLab/ruku',
    },
  ],
  topNav: [
    { text: 'Docs', link: '/getting-started', match: '/docs' },
  ]
});
