module.exports = {
    rules: {
        'scope-enum': [
            1,  // You can enforce this by setting this value to 2
            'always',
            [
                // You should define them per project organizing around
                // higher level the core concepts within your project
                'please-define-in-project-commitlint.types.js'
            ]
        ],
        'type-enum': [
            2,
            'always',
            [
                // Changes that affect the build or external
                // dependencies (example: modification to Dockerfile)
                'builds',
                // Changes to the build process or auxiliary tools and
                // libraries such as documentation generation
                'chore',
                // Changes to our CI configuration files and scripts
                'ci',
                // Documentation only changes
                'docs',
                // A new feature
                'feat',
                // A bug fix
                'fix',
                // A code change that improves performance
                'perf',
                // A code change that neither fixes a bug nor adds a feature
                'refactor',
                // Reverting erroneous commmit(s)
                'revert',
                // Changes that do not affect the meaning of the code
                // (white-space, formatting, missing semi-colons, etc)
                'style',
                // Adding missing tests or correcting existing tests
                'test'
            ]
        ]
    }
};
