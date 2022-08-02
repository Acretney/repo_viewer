// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../../../auth/1_presentation/authorization_page.dart' as _i3;
import '../../../auth/1_presentation/sign_in_page.dart' as _i2;
import '../../../github/repos/searched_repos/1_presentation/searched_repos_page.dart'
    as _i5;
import '../../../github/repos/starred_repos/1_presentation/starred_repos_page.dart'
    as _i4;
import '../../../splash/1_presentation/splash_page.dart' as _i1;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashPage());
    },
    SignInRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.SignInPage());
    },
    AuthorizationRoute.name: (routeData) {
      final args = routeData.argsAs<AuthorizationRouteArgs>();
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.AuthorizationPage(
              key: args.key,
              authorizationURL: args.authorizationURL,
              onAuthorizationCodeRedirectAttempt:
                  args.onAuthorizationCodeRedirectAttempt));
    },
    StarredReposRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.StarredReposPage());
    },
    SearchedReposRoute.name: (routeData) {
      final args = routeData.argsAs<SearchedReposRouteArgs>();
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.SearchedReposPage(
              key: args.key, searchTerm: args.searchTerm));
    }
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(SplashRoute.name, path: '/'),
        _i6.RouteConfig(SignInRoute.name, path: '/sign-in'),
        _i6.RouteConfig(AuthorizationRoute.name, path: '/auth'),
        _i6.RouteConfig(StarredReposRoute.name, path: '/starred'),
        _i6.RouteConfig(SearchedReposRoute.name, path: '/search')
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.SignInPage]
class SignInRoute extends _i6.PageRouteInfo<void> {
  const SignInRoute() : super(SignInRoute.name, path: '/sign-in');

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i3.AuthorizationPage]
class AuthorizationRoute extends _i6.PageRouteInfo<AuthorizationRouteArgs> {
  AuthorizationRoute(
      {_i7.Key? key,
      required Uri authorizationURL,
      required void Function(Uri) onAuthorizationCodeRedirectAttempt})
      : super(AuthorizationRoute.name,
            path: '/auth',
            args: AuthorizationRouteArgs(
                key: key,
                authorizationURL: authorizationURL,
                onAuthorizationCodeRedirectAttempt:
                    onAuthorizationCodeRedirectAttempt));

  static const String name = 'AuthorizationRoute';
}

class AuthorizationRouteArgs {
  const AuthorizationRouteArgs(
      {this.key,
      required this.authorizationURL,
      required this.onAuthorizationCodeRedirectAttempt});

  final _i7.Key? key;

  final Uri authorizationURL;

  final void Function(Uri) onAuthorizationCodeRedirectAttempt;

  @override
  String toString() {
    return 'AuthorizationRouteArgs{key: $key, authorizationURL: $authorizationURL, onAuthorizationCodeRedirectAttempt: $onAuthorizationCodeRedirectAttempt}';
  }
}

/// generated route for
/// [_i4.StarredReposPage]
class StarredReposRoute extends _i6.PageRouteInfo<void> {
  const StarredReposRoute() : super(StarredReposRoute.name, path: '/starred');

  static const String name = 'StarredReposRoute';
}

/// generated route for
/// [_i5.SearchedReposPage]
class SearchedReposRoute extends _i6.PageRouteInfo<SearchedReposRouteArgs> {
  SearchedReposRoute({_i7.Key? key, required String searchTerm})
      : super(SearchedReposRoute.name,
            path: '/search',
            args: SearchedReposRouteArgs(key: key, searchTerm: searchTerm));

  static const String name = 'SearchedReposRoute';
}

class SearchedReposRouteArgs {
  const SearchedReposRouteArgs({this.key, required this.searchTerm});

  final _i7.Key? key;

  final String searchTerm;

  @override
  String toString() {
    return 'SearchedReposRouteArgs{key: $key, searchTerm: $searchTerm}';
  }
}