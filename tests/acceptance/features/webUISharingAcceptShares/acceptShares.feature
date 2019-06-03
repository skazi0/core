@webUI @insulated @disablePreviews
Feature: accept/decline shares coming from internal users
  As a user
  I want to have control of which received shares I accept
  So that I can keep my file system clean

  Background:
#    Given these users have been created with default attributes:
#      | username |
#      | user1    |
#      | user2    |
    Given user "user1" has been created with default attributes and without skeleton files
    Given user "user2" has been created with default attributes
    And these groups have been created:
      | groupname |
      | grp1      |
    And user "user1" has been added to group "grp1"
    And user "user2" has been added to group "grp1"

  @smokeTest
  Scenario: Auto-accept disabled results in "Pending" shares
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with group "grp1"
    And user "user2" has shared file "/testimage.jpg" with user "user1"
    When user "user1" logs in using the webUI
    Then folder "simple-folder" should not be listed on the webUI
    And file "testimage.jpg" should not be listed on the webUI
    But folder "simple-folder" should be listed in the shared-with-you page on the webUI
    And file "testimage.jpg" should be listed in the shared-with-you page on the webUI
    And folder "simple-folder" should be in state "Pending" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI

  Scenario: receive shares with same name from different users
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user3" has been created with default attributes
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user3" has shared folder "/simple-folder" with user "user1"
    When user "user1" logs in using the webUI
    Then folder "simple-folder" shared by "User Three" should be in state "Pending" in the shared-with-you page on the webUI
    And folder "simple-folder" shared by "User Two" should be in state "Pending" in the shared-with-you page on the webUI

  Scenario: receive shares with same name from different users, accept one by one
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user3" has been created with default attributes and without skeleton files
    And user "user2" has created folder "/simple-folder/from_user2"
    And user "user2" has shared folder "/simple-folder" with user "user3"
    And user "user1" has created folder "/simple-folder"
    And user "user1" has created folder "/simple-folder/from_user1"
    And user "user1" has shared folder "/simple-folder" with user "user3"
    And user "user3" has logged in using the webUI
    When the user accepts share "simple-folder" offered by user "User One" using the webUI
    And the user accepts share "simple-folder" offered by user "User Two" using the webUI
    Then folder "simple-folder" shared by "User One" should be in state "" in the shared-with-you page on the webUI
    And folder "simple-folder (2)" shared by "User Two" should be in state "" in the shared-with-you page on the webUI
    And user "user3" should see the following elements
      | /simple-folder/from_user1/       |
      | /simple-folder%20(2)/from_user2/ |

  Scenario: receive shares with same name from different users
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user3" has been created with default attributes
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user3" has shared folder "/simple-folder" with user "user1"
    When user "user1" logs in using the webUI
    Then folder "simple-folder" shared by "User Three" should be in state "Pending" in the shared-with-you page on the webUI
    And folder "simple-folder" shared by "User Two" should be in state "Pending" in the shared-with-you page on the webUI

  @smokeTest
  Scenario: accept an offered share
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user2" has shared file "/testimage.jpg" with user "user1"
    And user "user1" has logged in using the webUI
    When the user accepts share "simple-folder" offered by user "User Two" using the webUI
    Then folder "simple-folder" should be in state "" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI
    And folder "simple-folder" should be in state "" in the shared-with-you page on the webUI after a page reload
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI after a page reload
    And folder "simple-folder" should be listed in the files page on the webUI
    And file "testimage.jpg" should not be listed in the files page on the webUI

  @smokeTest
  Scenario: decline an offered (pending) share
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user2" has shared file "/testimage.jpg" with user "user1"
    And user "user1" has logged in using the webUI
    When the user declines share "simple-folder" offered by user "User Two" using the webUI
    Then folder "simple-folder" should be in state "Declined" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI
    And folder "simple-folder" should not be listed in the files page on the webUI
    And file "testimage.jpg" should not be listed in the files page on the webUI

  @smokeTest
  Scenario: decline an accepted share (with page-reload in between)
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user2" has shared file "/testimage.jpg" with user "user1"
    And user "user1" has logged in using the webUI
    When the user accepts share "simple-folder" offered by user "User Two" using the webUI
    And the user reloads the current page of the webUI
    And the user declines share "simple-folder" offered by user "User Two" using the webUI
    Then folder "simple-folder" should be in state "Declined" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI
    And folder "simple-folder" should not be listed in the files page on the webUI
    And file "testimage.jpg" should not be listed in the files page on the webUI

  Scenario: decline an accepted share (without any page-reload in between)
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user2" has shared file "/testimage.jpg" with user "user1"
    And user "user1" has logged in using the webUI
    When the user accepts share "simple-folder" offered by user "User Two" using the webUI
    And the user declines share "simple-folder" offered by user "User Two" using the webUI
    Then folder "simple-folder" should be in state "Declined" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI
    And folder "simple-folder" should not be listed in the files page on the webUI
    And file "testimage.jpg" should not be listed in the files page on the webUI

  Scenario: accept a previously declined share
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user2" has shared file "/testimage.jpg" with user "user1"
    And user "user1" has logged in using the webUI
    And the user declines share "simple-folder" offered by user "User Two" using the webUI
    When the user accepts share "simple-folder" offered by user "User Two" using the webUI
    Then folder "simple-folder" should be in state "" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI
    And folder "simple-folder" should be listed in the files page on the webUI
    And file "testimage.jpg" should not be listed in the files page on the webUI

  Scenario: accept a share that you received as user and as group member
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user2" has shared folder "/simple-folder" with group "grp1"
    And user "user1" has logged in using the webUI
    When the user accepts share "simple-folder" offered by user "User Two" using the webUI
    And the user reloads the current page of the webUI
    Then folder "simple-folder" should be in state "" in the shared-with-you page on the webUI
    And folder "simple-folder" should be listed in the files page on the webUI

  Scenario: reject a share that you received as user and as group member
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user2" has shared folder "/simple-folder" with group "grp1"
    And user "user1" has logged in using the webUI
    When the user declines share "simple-folder" offered by user "User Two" using the webUI
    And the user reloads the current page of the webUI
    Then folder "simple-folder" should be in state "Declined" in the shared-with-you page on the webUI
    And folder "simple-folder" should not be listed in the files page on the webUI

  Scenario: reshare a share that you received to a group that you are member of
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    When the user accepts share "simple-folder" offered by user "User Two" using the webUI
    And the user has browsed to the files page
    And the user shares folder "simple-folder" with group "grp1" using the webUI
    And the user declines share "simple-folder" offered by user "User Two" using the webUI
    And the user reloads the current page of the webUI
    Then folder "simple-folder" should be in state "Declined" in the shared-with-you page on the webUI
    And folder "simple-folder" should not be listed in the files page on the webUI

  @smokeTest
  Scenario: unshare an accepted share on the "All files" page
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user2" has shared folder "/testimage.jpg" with group "grp1"
    And user "user1" has accepted the share "/simple-folder" offered by user "user2"
    And user "user1" has accepted the share "/testimage.jpg" offered by user "user2"
    And user "user1" has logged in using the webUI
    When the user unshares folder "simple-folder" using the webUI
    And the user unshares file "testimage.jpg" using the webUI
    Then folder "simple-folder" should not be listed in the files page on the webUI
    And file "testimage.jpg" should not be listed in the files page on the webUI
    And folder "simple-folder" should be in state "Declined" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Declined" in the shared-with-you page on the webUI

  @smokeTest
  Scenario: Auto-accept shares
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user2" has shared folder "/simple-folder" with group "grp1"
    And user "user2" has shared folder "/testimage.jpg" with user "user1"
    When user "user1" logs in using the webUI
    Then folder "simple-folder" should be listed on the webUI
    And file "testimage.jpg" should be listed on the webUI
    And folder "simple-folder" should be listed in the shared-with-you page on the webUI
    And file "testimage.jpg" should be listed in the shared-with-you page on the webUI
    And folder "simple-folder" should be in state "" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "" in the shared-with-you page on the webUI

  Scenario: decline auto-accepted shares
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user2" has shared folder "/simple-folder" with group "grp1"
    And user "user2" has shared folder "/testimage.jpg" with user "user1"
    And user "user1" has logged in using the webUI
    When the user declines share "simple-folder" offered by user "User Two" using the webUI
    And the user declines share "testimage.jpg" offered by user "User Two" using the webUI
    And the user has browsed to the files page
    Then folder "simple-folder" should not be listed on the webUI
    And file "testimage.jpg" should not be listed on the webUI
    And folder "simple-folder" should be in state "Declined" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Declined" in the shared-with-you page on the webUI

  Scenario: unshare auto-accepted shares
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user2" has shared folder "/simple-folder" with group "grp1"
    And user "user2" has shared folder "/testimage.jpg" with user "user1"
    And user "user1" has logged in using the webUI
    When the user unshares folder "simple-folder" using the webUI
    And the user unshares file "testimage.jpg" using the webUI
    Then folder "simple-folder" should not be listed on the webUI
    And file "testimage.jpg" should not be listed on the webUI
    And folder "simple-folder" should be in state "Declined" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Declined" in the shared-with-you page on the webUI

  Scenario: unshare renamed shares
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user1" has moved folder "/simple-folder" to "/simple-folder-renamed"
    And user "user1" has logged in using the webUI
    When the user unshares folder "simple-folder-renamed" using the webUI
    Then folder "simple-folder-renamed" should not be listed on the webUI
    And folder "simple-folder-renamed" should be in state "Declined" in the shared-with-you page on the webUI

  Scenario: unshare moved shares
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user1" has created folder "/new-folder"
    And user "user1" has moved folder "/simple-folder" to "/new-folder/shared"
    And user "user1" has logged in using the webUI
    When the user opens folder "new-folder" using the webUI
    And the user unshares folder "shared" using the webUI
    Then folder "shared" should not be listed on the webUI
    And folder "shared" should be in state "Declined" in the shared-with-you page on the webUI

  Scenario: unshare renamed shares, accept it again
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user2" has shared folder "/simple-folder" with user "user1"
    And user "user1" has moved folder "/simple-folder" to "/simple-folder-renamed"
    And user "user1" has logged in using the webUI
    When the user unshares folder "simple-folder-renamed" using the webUI
    And the user accepts share "simple-folder-renamed" offered by user "User Two" using the webUI
    Then folder "simple-folder-renamed" should be in state "" in the shared-with-you page on the webUI
    And folder "simple-folder-renamed" should be listed in the files page on the webUI

  Scenario: User-based accepting is disabled while global is enabled
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal sharing settings page
    When the user disables automatically accepting new incoming local shares
    And user "user2" shares folder "/simple-folder" with group "grp1" using the sharing API
    And user "user2" shares file "/testimage.jpg" with user "user1" using the sharing API
    And the user browses to the files page
    Then folder "simple-folder" should not be listed on the webUI
    And file "testimage.jpg" should not be listed on the webUI
    But folder "simple-folder" should be listed in the shared-with-you page on the webUI
    And file "testimage.jpg" should be listed in the shared-with-you page on the webUI
    And folder "simple-folder" should be in state "Pending" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI

  Scenario: User-based accepting is enabled while global is enabled
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal sharing settings page
    When the user enables automatically accepting new incoming local shares
    And user "user2" shares folder "/simple-folder" with group "grp1" using the sharing API
    And user "user2" shares file "/testimage.jpg" with user "user1" using the sharing API
    And the user browses to the files page
    Then folder "simple-folder" should be listed on the webUI
    And file "testimage.jpg" should be listed on the webUI
    And folder "simple-folder" should be listed in the shared-with-you page on the webUI
    And file "testimage.jpg" should be listed in the shared-with-you page on the webUI
    And folder "simple-folder" should be in state "" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "" in the shared-with-you page on the webUI

  Scenario: User-based accepting checkbox is not visible while global is disabled
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal sharing settings page
    Then User-based auto accepting checkbox should not be displayed on the personal sharing settings page on the webUI

  Scenario: Admin disables auto-accept setting again after user enabled personal auto-accept setting
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been enabled
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal sharing settings page
    When the user disables automatically accepting new incoming local shares
    And the user enables automatically accepting new incoming local shares
    And the administrator disables the setting "Automatically accept new incoming local user shares" in the section "Sharing"
    And user "user2" shares folder "/simple-folder" with group "grp1" using the sharing API
    And user "user2" shares file "/testimage.jpg" with user "user1" using the sharing API
    And the user browses to the files page
    Then folder "simple-folder" should not be listed on the webUI
    And file "testimage.jpg" should not be listed on the webUI
    And folder "simple-folder" should be listed in the shared-with-you page on the webUI
    And file "testimage.jpg" should be listed in the shared-with-you page on the webUI
    And folder "simple-folder" should be in state "Pending" in the shared-with-you page on the webUI
    And file "testimage.jpg" should be in state "Pending" in the shared-with-you page on the webUI
