#  Architectural Patterns

## Goal

An architectural pattern is a general, reusable solution to a commonly occurring problem in software architecture. 
In iOS, we encounter multiple architectural patterns from popular ones to the most common MVC.

Our goal here is to create the same app following different patterns to learn the pros and cons of each while discovering that there can be more layers and abstractions than the ones outlined in each pattern.

We will also attempt to show that the same dependencies can be used in each pattern by plugging it into the right layer.

## Cocktail App

API: [thecocktaildb](https://www.thecocktaildb.com/api.php)

The app will be a catalog of cocktail that requires you to log in first before you can browse it.

1. You will be prompted to Log in presenting 2 text fields (email, password) and 1 button (enter).
> At this point we will expect to validate the email and the password before enabling the button.
> Once the button is enabled and you tap it:
> * If the user exists and the password is correct you should be redirected to the list of cocktails.
> * If the user doesn't exist you should be prompt to accept T&C to create a new user
> * If the password is wrong you should be prompt with the error message.

2. Once in you should see a Cocktails list that you can scroll (no need to handle pagination)
> Each cocktail should have the option to favorite

3. If a Cocktail is tapped it should navigate into a detail

4. In the list we should show a button or tab that allows browsing the favorite Cocktails

5. In the Favorite list we should allow a way to unfavorite a Cocktail

Every implementation should count with the proper UT.

## Patterns

1. [MVC](../CaseStudies/02-ArchitecturalPatterns/MVC)
