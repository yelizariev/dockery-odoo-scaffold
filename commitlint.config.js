module.exports = {
    rules: {
        'body-leading-blank': [1, 'always'],
        'footer-leading-blank': [1, 'always'],
        'header-max-length': [2, 'always', 72],
        'scope-case': [2, 'always', 'lower-case'],
        'subject-case': [
            2,
            'never',
            ['sentence-case', 'start-case', 'pascal-case', 'upper-case']
        ],
        'subject-empty': [2, 'never'],
        'subject-full-stop': [2, 'never', '.'],
        'type-case': [2, 'always', 'lower-case'],
        'type-empty': [2, 'never'],
        'type-enum': [
            2,
            'always',
            [
                // Changes that affect the build or external
                // dependencies (example: modification to Dockerfile)
                'build',
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
