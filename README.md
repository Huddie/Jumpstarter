
# Welcome! 👋 to Jumpstarter ⚡️


## What is Jumpstarter?

We're glad you asked! 

Barrier to entry is always something we as open source developers are trying to lower. Afterall open source projects are as powerful as its maintainers so wouldn't you want to make becoming a contributor/maintainer easier?

From personal experience i've noticed that as hard as a developer tries to write a good contributing guide, getting setup can be a drag. You have to read and re-read each instruction, download additional dependencies and not to mention these instructions are different depending on your OS. Instead of wasting time writing up a guide and then answering and helping people afterwards we have decided to offer the ability to write up a Start file. 

A start file makes getting setup a breeze for the contributor because they have to do... well... nothing. WHAT?!?!. Here's an example:

```bash
git fork Huddie/Grade-Notifier
git clone Grade-Notifier
cd Grade-Notifier
bash run ./Depfiles/depinstall.sh
```

So what does this do? 

1. Forks the repository 
2. Clones it
3. Installs all the dependencies

This is a fairly simply Start file.

Notice how the creator of the Start file didn't have to write instructions for a specific OS. Notice how you can make use of powerful instructions like `git fork`. 

We hope that Start files will lower the barrier to entry so developers can focus on developing.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Maintainer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/maintainer/blob/master/CODE_OF_CONDUCT.md).
